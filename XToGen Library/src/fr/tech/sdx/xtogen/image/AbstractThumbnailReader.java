/** 
 *  Fichier: AbstractThumbnailReader.java
 * 
 *	XtoGen - Générateur d'applications SDX2
 * 	Copyright (C) 2003 Ministère de la culture et de la communication, PASS Technologie
 *
 *	Ministère de la culture et de la communication,
 *	Mission de la recherche et de la technologie
 *	3 rue de Valois, 75042 Paris Cedex 01 (France)
 *	mrt@culture.fr, michel.bottin@culture.fr
 *
 *	PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
 *	Nader Boutros, nader.boutros@pass-tech.fr
 *	Pierre Dittgen, pierre.dittgen@pass-tech.fr
 *
 *	Ce programme est un logiciel libre: vous pouvez le redistribuer
 *	et/ou le modifier selon les termes de la "GNU General Public
 *	License", tels que publiés par la "Free Software Foundation"; soit
 *	la version 2 de cette licence ou (à votre choix) toute version
 *	ultéieure.
 *
 *	Ce programme est distribué dans l'espoir qu'il sera utile, mais
 *	SANS AUCUNE GARANTIE, ni explicite ni implicite; sans même les
 *	garanties de commercialisation ou d'adaptation dans un but spécifique.
 *
 *	Se référer à la "GNU General Public License" pour plus de détails.
 *
 *	Vous devriez avoir reçu une copie de la "GNU General Public License"
 *	en même temps que ce programme; sinon, écrivez à la "Free Software
 *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
 */
package fr.tech.sdx.xtogen.image;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Map;

import org.apache.avalon.framework.component.ComponentException;
import org.apache.avalon.framework.component.ComponentManager;
import org.apache.avalon.framework.component.Composable;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.Context;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.Response;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.reading.AbstractReader;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import fr.gouv.culture.sdx.exception.SDXException;
import fr.gouv.culture.sdx.exception.SDXExceptionCode;
import fr.tech.sdx.xtogen.util.FileHelper;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public abstract class AbstractThumbnailReader extends AbstractReader implements Composable
{
	protected static final String PNG_MIMETYPE = "image/png";
	private static final Logger LOG = Logger.getLogger(AbstractThumbnailReader.class);
	
	protected ComponentManager		_manager		= null;
	protected Response				_response		= null;
	protected Request				_request		= null;
	protected File					_iconDirectory	= null;
	protected AbstractDocumentBean	_adb			= null;

	protected abstract AbstractDocumentBean newAttachDocumentBean(Parameters par, ComponentManager manager, String baseDirectory);

	/**
	 * Setup
	 * @param resolver Resolver
	 * @param src Source
	 * @param par Parameters
	 */
	public void setup(SourceResolver resolver, Map map, String src, Parameters par)
		throws ProcessingException, SAXException, IOException
	{
		super.setup(resolver, map, src, par);
		
		// can't get a response and a acceptRequest by this way (copy/paste from other readers)
		try
		{
			_response = ObjectModelHelper.getResponse(map);
			_request = ObjectModelHelper.getRequest(map);
		}
		catch (Exception e)
		{
			LOG.error("can't get response or acceptRequest", e);
		}
		
		// parameters getted by a correct config of sitemap
		if (_manager == null)
		{
			SDXException sdxE = new SDXException(null,
				SDXExceptionCode.ERROR_COMPONENT_MANAGER_NULL, null, null);
			throw new ProcessingException(sdxE.getMessage(), sdxE);
		}
		
		Context context = ObjectModelHelper.getContext(map);
		_adb = newAttachDocumentBean(par, _manager, FileHelper.getBaseDir(context, _request));
	}
	
	/**
	 * Composable interface
	 */
	public void compose(ComponentManager manager) throws ComponentException
	{
		_manager = manager;
	}

	/** 
	 * Writes result
	 */
	public void generate() throws IOException, SAXException, ProcessingException
	{
		if (out == null)
			LOG.error("No output stream defined");
		
		// The work has to be done
		File thumbnail = getThumbnail();
	
		// Header
		LOG.debug("Thumbnail file = " + thumbnail.getAbsolutePath());
		_response.setHeader("Accept-Ranges", "none");
		_response.setHeader("Content-type", getMimeType());
		
		long contentLength = thumbnail.length();
		if (contentLength != 0)
		{
			// First time get doesn't return valid size
			_response.setHeader("Content-length", Long.toString(contentLength));
			LOG.debug("Content length = " + Long.toString(thumbnail.length()));
		}		
	
		// File content
		FileHelper.copy(new FileInputStream(thumbnail), out);
		out.flush();
	}

	/**
	 * Gets thumbnail file for an attached document, creates it if necessary
	 * @return Thumbnail file
	 */
	private File getThumbnailFile()
		throws Exception
	{
		String filename = _adb.computeThumbnailFileName();
		File thumbnailFile = new File(filename);
		LOG.debug("Thumbnail file is [" + filename + "]");
		
		// Creates thumbnail if it doesn't exist
		if (!thumbnailFile.exists())
		{
			LOG.debug("Thumbnail file doesn't exist, create it!");
			createThumbnail();
		}
		else LOG.debug("Thumbnail file already exists");
		
		return thumbnailFile;
	}

		/**
	 * Gets thumbnail for an attach document
	 * @return Thumbnail file
	 */
	private File getThumbnail()
	{
		String mimeType = _adb.getMimeType();
		LOG.debug("mimeType == " + mimeType);
		
		// Unknown type
		if (mimeType == null)
			return getDefaultThumbFile();
			
		// Image type
		if (isImage(mimeType))
		{
			LOG.debug("Mime type is an image type");
			try
			{
				return getThumbnailFile();
			}
			catch (Exception e)
			{
				LOG.error("Can't create/get thumbnail file", e);
				return getDefaultThumbFile();
			}
		}
		
		// Known type
		LOG.debug("Mime type is not an image type");
		return getThumbnailFromType(mimeType);
	}

	/**
	 * Creates the thumbnail
	 *
	 */
	private void createThumbnail()
		throws Exception
	{
		_adb.createThumbnail();
	}

	/**
	 * @param mimeType mime type
	 * @return Thumbnail file
	 */
	private File getThumbnailFromType(String mimeType)
	{
		String despecializedMimeType
			= mimeType.replace('/', '_').replace('.','_');
		File thumbFile = new File(_adb.getIconDirectory(),
			despecializedMimeType + ".png");
		if (thumbFile.exists())
			return thumbFile;

		return getDefaultThumbFile();
	}
	
	/**
	 * Gets default thumbnail file
	 * @return Default thumbnail file
	 */
	private File getDefaultThumbFile()
	{
		return new File(_adb.getIconDirectory(), "default_type.png");
	}

	/**
	 * Indicates if the mime type describes an image or not
	 * @return true or false
	 */
	private boolean isImage(String mimeType)
	{
		if (mimeType == null)
            throw new IllegalArgumentException("mime-type is null");
		
		return (
				"image/jpeg".equals(mimeType)
			||	"image/png".equals(mimeType)
			||	"image/gif".equals(mimeType));
	}
	
	/**
	 * Get the mime-type of the output of this <code>Serializer</code>
	 * This default implementation returns null to indicate that the
	 * mime-type specified in the sitemap is to be used
	 */
	public String getMimeType()
	{
		// All thumbnails are in PNG format
		return PNG_MIMETYPE;
	}

}

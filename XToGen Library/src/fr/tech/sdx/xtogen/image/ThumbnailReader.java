/** 
 *  Fichier: ThumbnailReader.java
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
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

import fr.gouv.culture.sdx.application.Application;
import fr.gouv.culture.sdx.document.BinaryDocument;
import fr.gouv.culture.sdx.document.Document;
import fr.gouv.culture.sdx.documentbase.DocumentBase;
import fr.gouv.culture.sdx.exception.SDXException;
import fr.gouv.culture.sdx.exception.SDXExceptionCode;
import fr.gouv.culture.sdx.framework.Framework;
import fr.gouv.culture.sdx.framework.FrameworkImpl;
import fr.tech.sdx.xtogen.util.FileHelper;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public class ThumbnailReader extends AbstractReader implements Composable
{
	// Logger
	private static final Logger LOG
		= Logger.getLogger(ThumbnailReader.class);

	private static final String PNG_MIMETYPE = "image/png";
		
	private ComponentManager	_manager = null;
	private Response			_response = null;
	private Request				_request = null;
	private File				_iconDirectory = null;
	private AttachDocumentBean	_adb = null;

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
		setIconDirectory(new File(FileHelper.getBaseDir(context, _request) + File.separator + "conf" + File.separator + "thn"));

		_adb = new AttachDocumentBean(par);
	}

	/** 
	 * Writes result
	 */
	public void generate()
		throws IOException, SAXException, ProcessingException
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
		copy(new FileInputStream(thumbnail), out);
		out.flush();
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
	 * Gets thumbnail file for an attached document, creates it if necessary
	 * @return Thumbnail file
	 */
	private File getThumbnailFile()
		throws Exception
	{
		String filename = _adb.computeThumbnailFileName(getIconDirectory());
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
	 * Creates the thumbnail
	 *
	 */
	private void createThumbnail()
		throws Exception
	{
		// Download attached file in a temp file
		File tempFile = File.createTempFile("xtg", "thn");
		LOG.debug("Temporary file = [" + tempFile + "]");
		_adb.downloadAttachFile(tempFile);

		// Creates the thumbnail
		try
		{
			File thumbFile = new File(_adb.computeThumbnailFileName(getIconDirectory()));
			ThumbnailCreator tc = new ThumbnailCreator(tempFile);
			tc.createThumbnail(thumbFile, 
				_adb.getMaxWidth(), _adb.getMaxHeight());
			LOG.debug("Thumbnail created");
		}
		catch (Throwable t)
		{
			LOG.error("Error while creating thumbnail", t);
		}
		
		// Cleaning
		tempFile.delete();
	}

	/**
	 * @param mimeType mime type
	 * @return Thumbnail file
	 */
	private File getThumbnailFromType(String mimeType)
	{
		String despecializedMimeType
			= mimeType.replace('/', '_').replace('.','_');
		File thumbFile = new File(getIconDirectory(),
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
		return new File(getIconDirectory(), "default_type.png");
	}

	/**
	 * Indicates if the mime type describes an image or not
	 * @return true or false
	 */
	private boolean isImage(String mimeType)
	{
		assert (mimeType != null);
		
		return (
				"image/jpeg".equals(mimeType)
			||	"image/png".equals(mimeType)
			||	"image/gif".equals(mimeType));
	}
	
	/**
	 * Copy in into out
	 * @param in Input stream
	 * @param out Output stream
	 * @throws IOException If something bad occurs
	 */
	private void copy(InputStream in, OutputStream out)
		throws IOException
	{
		LOG.debug("Copy begin");
		byte[] buffer = new byte[8192];
		int length = -1;

		while ((length = in.read(buffer)) > -1) {
			out.write(buffer, 0, length);
		}
		in.close();
		in = null;
		out.flush();
		LOG.debug("Copy end");
	}

	/**
	 * Composable interface
	 */
	public void compose(ComponentManager manager) throws ComponentException
	{
		_manager = manager;
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

	/**
	 * Sets new icon directory
	 * @param iconDirectory
	 */
	private void setIconDirectory(File iconDirectory)
	{
		_iconDirectory = iconDirectory;
	}

	/**
	 * Gets Icon directory (creates it if it doesn't exist
	 * @return Icon directory
	 */
	private File getIconDirectory()
	{
		if (!_iconDirectory.exists())
			_iconDirectory.mkdirs();
		return _iconDirectory;
	}

	/**
	 * Simple class to get information from URL
	 */
	private class AttachDocumentBean
	{
		private static final String SIZE_REGEX	= "([0-9]{2,3})x([0-9]{2,3})";
		private static final String APP_PARAM	= "app";
		private static final String BASE_PARAM	= "base";
		private static final String ID_PARAM	= "id";
		private static final String SIZE_PARAM	= "size";
		
		private String	_appId		= null;
		private String	_baseId		= null;
		//private String	_docId		= null;
		private String	_attachId	= null;
		private String	_maxSize	= null;
		private int		_maxWidth	= 0;
		private int		_maxHeight	= 0;

		/**
		 * Constructor
		 * @param par Parameters
		 */
		public AttachDocumentBean(Parameters par)
		{
			_appId = par.getParameter(APP_PARAM, null);
			_baseId = par.getParameter(BASE_PARAM, null);
			_attachId = par.getParameter(ID_PARAM, null);
			_maxSize = par.getParameter(SIZE_PARAM, null);
			
			LOG.debug("Application = " + _appId);
			LOG.debug("Base = " + _baseId);
			LOG.debug("Attach id = " + _attachId);
			if (!checkSize())
			{
				LOG.warn("Size string is bad formed!!!");
				_maxSize = "150x150";
			}
			computeWidthAndHeight();
		}
		
		/**
		 * Computes width and height from size string
		 */
		private void computeWidthAndHeight()
		{
			Pattern p = Pattern.compile(SIZE_REGEX);
			Matcher m = p.matcher(_maxSize);
			m.matches();
			_maxWidth = Integer.parseInt(m.group(1));
			_maxHeight = Integer.parseInt(m.group(2));
			LOG.debug("Max size = " + _maxSize);
			LOG.debug("Computed max width = " + _maxWidth);
			LOG.debug("Computed max height = " + _maxHeight);
		}

		/**
		 * Checks if size is given using right syntax
		 * @return true if ok, else false
		 */
		private boolean checkSize()
		{
			LOG.debug("chechSize(\"" + _maxSize + "\")");
			
			if (_maxSize == null)
				return false;
			return Pattern.matches(SIZE_REGEX, _maxSize);
		}
		
		/**
		 * @return Max height
		 */
		public int getMaxHeight()
		{
			return _maxHeight;
		}

		/**
		 * @return Max width
		 */
		public int getMaxWidth()
		{
			return _maxWidth;
		}

		/**
		 * Gets max size as a string
		 * @return <width>x<height>
		 */
		public String getMaxSize()
		{
			return _maxSize;
		}

		/**
		 * @param tempFile
		 */
		public void downloadAttachFile(File tempFile)
			throws IOException, SDXException
		{
			LOG.debug("Download attach file <" + tempFile + ">");
			FrameworkImpl frame = null;
			DocumentBase base = null;
			Document doc = null;
			
			try
			{
				frame = (FrameworkImpl)_manager.lookup(Framework.ROLE);
				if (frame != null)
				{
					Application app = frame.getApplicationById(_appId);
					if (app != null)
					{
						if (_baseId != null && !"".equals(_baseId))
								base = app.getDocumentBase(_baseId);
						else	base = app.getDefaultDocumentBase();
						doc = new BinaryDocument(getAttachIdentifier(), null, null);
					}
				}
				LOG.debug("Download ok");
			}
			catch (Exception e)
			{
				LOG.error("Exception while getting manager", e);
			}
			finally
			{
				if (frame != null)
					_manager.release(frame);
			}

			FileOutputStream fos = new FileOutputStream(tempFile);
			copy(base.getDocument(doc), fos);
			fos.close();
		}

		/**
		 * @return Mime type of attached document
		 */
		public String getMimeType()
		{
			String fileExtension = getFileExtension(_attachId); 
			
			return FileType.getMimeFromExtension(fileExtension);
		}

		/**
		 * @param file File to get extension
		 * @return file extension
		 */
		private String getFileExtension(String file)
		{
			int lastDotIndex = file.lastIndexOf('.');
			if (lastDotIndex == -1)
				return "";
			return file.substring(lastDotIndex+1);
		}

		/**
		 * @param iconDirectory Compute thumbnail file name from base directory
		 * @return Thumbnail file name
		 */
		public String computeThumbnailFileName(File iconDirectory)
		{
			File directory = new File(iconDirectory.getAbsolutePath()
				+ File.separator + _baseId
				+ File.separator + _maxSize);
			if (!directory.exists())
				directory.mkdirs();
			
			String attachId = _attachId;
			LOG.debug("ATTACH ID BEFORE = " + attachId);
			attachId = attachId.replace('\\', '_');
			attachId = attachId.replace('/', '_');
			attachId = attachId.replace('.', '_');
			LOG.debug("ATTACH ID AFTER = " + attachId);
			
			String thnFileName = directory.getAbsolutePath() + File.separator
				+ attachId + "_thn.png";
			LOG.debug("Thumbnail filename = <" + thnFileName + ">");
			return thnFileName; 
		}

		/**
		 * Gets attach identifier
		 * @return Attach identifier
		 */
		public String getAttachIdentifier()
		{
			//if (Utilities.checkString(_attachId))
			//	return Utilities.attId(_docId, _attachId);
			return _attachId;
		}
	}
}

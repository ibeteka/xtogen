/** 
 *  Fichier: ThumbnailSDXReader.java
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
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.avalon.framework.component.ComponentManager;
import org.apache.avalon.framework.component.Composable;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.log4j.Logger;

import fr.gouv.culture.sdx.application.Application;
import fr.gouv.culture.sdx.document.BinaryDocument;
import fr.gouv.culture.sdx.document.Document;
import fr.gouv.culture.sdx.documentbase.DocumentBase;
import fr.gouv.culture.sdx.exception.SDXException;
import fr.gouv.culture.sdx.framework.Framework;
import fr.gouv.culture.sdx.framework.FrameworkImpl;
import fr.tech.sdx.xtogen.util.FileHelper;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 * A class to read thumbnail from image stored in SDX database
 */
public class ThumbnailSDXReader extends AbstractThumbnailReader implements Composable
{
	// Logger
	private static final Logger LOG
		= Logger.getLogger(ThumbnailSDXReader.class);

	/**
	 * Call to the factory
	 */
	protected AbstractDocumentBean newAttachDocumentBean(Parameters par, ComponentManager manager, String baseDirectory)
	{
		return new AttachDocumentBean(par, manager,
			new File(baseDirectory + File.separator + "conf" + File.separator + "thn"));
	}

	/**
	 * Simple class to get information from URL
	 */
	public static class AttachDocumentBean extends AbstractDocumentBean
	{
		private ComponentManager	_manager	= null;
		private String				_appId		= null;
		private String				_baseId		= null;
		private String				_attachId	= null;

		/**
		 * Constructor
		 * @param par Parameters
		 */
		public AttachDocumentBean(Parameters par, ComponentManager manager, File iconDirectory)
		{
			_manager	= manager;
			_appId		= par.getParameter("app", null);
			_baseId		= par.getParameter("base", null);
			_attachId	= par.getParameter("id", null);
			LOG.debug("Application = " + _appId);
			LOG.debug("Base = " + _baseId);
			LOG.debug("Attach id = " + _attachId);

			String maxSize = par.getParameter("size", null);
			_maxDim = computeSizeFromString(maxSize, 150, 150);
			setIconDirectory(iconDirectory);
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
						doc = new BinaryDocument(_attachId, null, null);
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
			FileHelper.copy(base.getDocument(doc), fos);
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
		 * @return Thumbnail file name
		 */
		public String computeThumbnailFileName()
		{
			File directory = new File(getIconDirectory().getAbsolutePath()
				+ File.separator + _baseId
				+ File.separator + _maxDim.width + 'x' + _maxDim.height);
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
	}
}

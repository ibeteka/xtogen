/** 
 *  Fichier: ThumbnailCreator.java
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
 *	ultérieure.
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

import java.awt.Container;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;

import javax.imageio.ImageIO;

import org.apache.log4j.Logger;


/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public class ThumbnailCreator
{
	// Logger
	private static final Logger LOG
		= Logger.getLogger(ThumbnailCreator.class);
		
	private File _imageFile = null;
	private static final float JPEG_QUALITY = 80.0f;
	
	/**
	 * Constructor
	 * @param imageFile
	 */
	public ThumbnailCreator(File imageFile)
	{
		if (imageFile == null)
            throw new IllegalArgumentException("Image file is null");
        if (!imageFile.exists() || !imageFile.canRead())
            throw new IllegalArgumentException("Image file " + imageFile
                    + " can't be found or is not readable");
		
		_imageFile = imageFile;
	}
	
	/**
	 * Is the file an image file?
	 * @return true if yes
	 */
	public boolean isImage()
	{
		String fileExtension = getFileExtension(_imageFile);
		return ("jpg".equalsIgnoreCase(fileExtension)
			||	"jpeg".equalsIgnoreCase(fileExtension)
			||	"png".equalsIgnoreCase(fileExtension)
			||	"gif".equalsIgnoreCase(fileExtension));
	}
	
	/**
	 * Creates the thumbnail
	 * @param thumbFile The filename to use
	 * @param maxWidth Max width
	 * @param maxHeight Max height
	 * @throws InterruptedException If something bad occurs
	 * @throws IOException If something weird occurs
	 */
	public void createThumbnail(File thumbFile, int maxWidth, int maxHeight)
		throws InterruptedException, IOException
	{
		if (thumbFile == null)
            throw new IllegalArgumentException("Thumbnail file is null");
		if (maxWidth <= 0 || maxHeight <= 0)
            throw new IllegalArgumentException("Invalid max width ("
                    + maxWidth + ") or height (" + maxHeight + ")");
		
		// Loads and reduces image		
		BufferedImage thumbImage = loadAndReduceImage(maxWidth, maxHeight);

		// Saves thumbnail image to OUTFILE
		String extension = getFileExtension(thumbFile);
		if ("jpg".equalsIgnoreCase(extension) || "jpeg".equalsIgnoreCase(extension))
			ImageIO.write(thumbImage, "jpeg", thumbFile);
		else if ("png".equalsIgnoreCase(extension))
			ImageIO.write(thumbImage, "png", thumbFile);
		else throw new IllegalArgumentException("Unknown extension: " + extension);
	}
	
	/**
	 * @param file File to get extension
	 * @return file extension
	 */
	private String getFileExtension(File file)
	{
		int lastDotIndex = file.getName().lastIndexOf('.');
		if (lastDotIndex == -1)
			return "";
		return file.getName().substring(lastDotIndex+1);
	}

	/**
	 * Loads the image and reduces it to the given thumbnail size
	 * @param maxWidth Max width
	 * @param maxHeight Max height
	 * @return The resized image
	 * @throws InterruptedException If something bad occurs
	 */
	private BufferedImage loadAndReduceImage(int maxWidth, int maxHeight)
		throws InterruptedException, IOException
	{
		// Pour être sûr que l'on n'utilise pas la connexion au serveur X
		System.setProperty("java.awt.headless", "true");

		// load image from INFILE
		Image image = Toolkit.getDefaultToolkit().getImage(_imageFile.getAbsolutePath());
		MediaTracker mediaTracker = new MediaTracker(new Container());
		mediaTracker.addImage(image, 0);
		mediaTracker.waitForID(0);
				
		// Determine thumbnail size from WIDTH and HEIGHT
		Dimension thumbDim = computeThumbnailDimension(
			image.getWidth(null), image.getHeight(null),
			maxWidth, maxHeight);

		// draw original image to thumbnail image object and
		// scale it to the new size on-the-fly (drawImage is quite powerful)
		BufferedImage thumbImage = new BufferedImage(thumbDim.width, 
			thumbDim.height, BufferedImage.TYPE_INT_RGB);
		Graphics2D graphics2D = thumbImage.createGraphics();
		graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
			RenderingHints.VALUE_INTERPOLATION_BILINEAR);
		graphics2D.drawImage(image, 0, 0, thumbDim.width, thumbDim.height, null);
		return thumbImage;
	}

	/**
	 * Computes thumbnail dimension
	 * @param imageWidth Image width
	 * @param imageHeight Image height
	 * @param maxWidth Max width
	 * @param maxHeight Max height
	 * @return Computed dimension
	 */
	static Dimension computeThumbnailDimension(int imageWidth, int imageHeight, int maxWidth, int maxHeight)
	{
		int thumbWidth = maxWidth;
		int thumbHeight = maxHeight;

		double thumbRatio = (double)thumbWidth / (double)thumbHeight;
		double imageRatio = (double)imageWidth / (double)imageHeight;

		if (thumbRatio < imageRatio)
				thumbHeight = (int)(thumbWidth / imageRatio);
		else	thumbWidth = (int)(thumbHeight * imageRatio);
		
		// Another test to avoid scaling the image
		if (thumbWidth > imageWidth || thumbHeight > imageHeight)
		{
			thumbWidth = imageWidth;
			thumbHeight = imageHeight;
		}

		return new Dimension(thumbWidth, thumbHeight);
	}

	/**
	 * Saves in JPG format
	 * @param thumbImage The image to save
	 * @param out Output stream to write in
	 * @throws IOException If something bad occurs
	 */
	private void saveToJpeg(BufferedImage thumbImage, OutputStream out, File outfile)
		throws IOException
	{
		ImageIO.write(thumbImage, "jpeg", outfile);
	}

	/**
	 * Saves in PNG format
	 * @param thumbImage The image to save
	 * @param out Output stream to write in
	 * @throws IOException If something bad occurs
	 */
	private void saveToPng(BufferedImage thumbImage, OutputStream out, File outfile)
		throws IOException
	{
		ImageIO.write(thumbImage, "png", outfile);
	}

	/**
	 * @param thumbDirectory Thumbnail directory
	 * @param thumbPrefix Thumbnail file prefix
	 * @param maxWidth Maximum thumbnail width
	 * @param maxHeight Maximum thumbnail height
	 * @return newly created thumbnail file
	 */
	public File createThumbnailInDirectory(File thumbDirectory, String thumbPrefix, int maxWidth, int maxHeight)
	{
		String baseFilename = getBaseFilename(_imageFile); 
		
		String thumbExtension = null;
		String fileExtension = getFileExtension(_imageFile);
		if ("jpg".equalsIgnoreCase(fileExtension) || "jpeg".equalsIgnoreCase(fileExtension))
				thumbExtension = "jpg";
		else	thumbExtension = "png";
		File thumbFile = new File(thumbDirectory,
			thumbPrefix + baseFilename + "." + thumbExtension);

		try
		{
			createThumbnail(thumbFile, maxWidth, maxHeight);
		}
		catch (Exception e)
		{
			LOG.error("Exception while creating thumbnail", e);
		}
		return thumbFile;
	}

	/**
	 * Gets basename of the file width extension dot transformed into underscore
	 * @param imageFile Image file
	 * @return Transformed name
	 */
	private String getBaseFilename(File imageFile)
	{
		String name = imageFile.getName();
		return name.replace('.', '_');
	}
}



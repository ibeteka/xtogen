/** 
 *  Fichier: Thumb.java
 * 
 *  XtoGen - Générateur d'applications SDX2
 *  Copyright (C) 2003 Ministère de la culture et de la communication, PASS Technologie
 *
 *  Ministère de la culture et de la communication,
 *  Mission de la recherche et de la technologie
 *  3 rue de Valois, 75042 Paris Cedex 01 (France)
 *  mrt@culture.fr, michel.bottin@culture.fr
 *
 *  PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
 *  Nader Boutros, nader.boutros@pass-tech.fr
 *  Pierre Dittgen, pierre.dittgen@pass-tech.fr
 *
 *  Ce programme est un logiciel libre: vous pouvez le redistribuer
 *  et/ou le modifier selon les termes de la "GNU General Public
 *  License", tels que publiés par la "Free Software Foundation"; soit
 *  la version 2 de cette licence ou (à votre choix) toute version
 *  ultérieure.
 *
 *  Ce programme est distribué dans l'espoir qu'il sera utile, mais
 *  SANS AUCUNE GARANTIE, ni explicite ni implicite; sans même les
 *  garanties de commercialisation ou d'adaptation dans un but spécifique.
 *
 *  Se référer à la "GNU General Public License" pour plus de détails.
 *
 *  Vous devriez avoir reçu une copie de la "GNU General Public License"
 *  en même temps que ce programme; sinon, écrivez à la "Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
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

import javax.imageio.ImageIO;

/**
 * @author Pierre Dittgen
 */
public class Thumb {

    /** Source file. */
    private File srcFile;

	/**
     * Constructor.
     * @param srcFile Source file
     */
    public Thumb(File aSrcFile) {
        srcFile = aSrcFile;
    }
    
    /**
     * Creates a thumbnail
     * @param dstFile Destination file
     * @param maxWidth Maximum width
     * @param maxHeight Maximum height
     * @throws IOException If a I/O error occurred
     * @throws InterruptedException If a thread (?) error occurred
     */
    public void createThumbnail(File dstFile, int maxWidth,
            int maxHeight) throws IOException, InterruptedException {

        // Loads and reduces image      
        BufferedImage thumbImage = loadAndReduceImage(maxWidth, maxHeight);

        // Saves thumbnail image to OUTFILE
        String extension = getFileExtension(dstFile);
        if (    "jpg".equalsIgnoreCase(extension)
            ||  "jpeg".equalsIgnoreCase(extension))
            ImageIO.write(thumbImage, "jpeg", dstFile);
        else if ("png".equalsIgnoreCase(extension))
            ImageIO.write(thumbImage, "png", dstFile);
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
        Image image = Toolkit.getDefaultToolkit()
            .getImage(srcFile.getAbsolutePath());
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
        graphics2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
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
    Dimension computeThumbnailDimension(int imageWidth,
            int imageHeight, int maxWidth, int maxHeight)
    {
        // If the image is already small enough
        if (imageWidth <= maxWidth && imageHeight <= maxHeight) {
        	return new Dimension(imageWidth, imageHeight);
        }
        
        // Else computes ratios
        double maxRatio = (double)maxWidth / (double)maxHeight;
        double imageRatio = (double)imageWidth / (double)imageHeight;

        // And scales width or height depending on ratio
        if (maxRatio < imageRatio) {
        	return new Dimension(maxWidth, (int)(maxWidth / imageRatio));
        } else {
        	return new Dimension((int)(maxHeight * imageRatio), maxHeight);
        }
    }
}

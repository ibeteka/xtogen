/** 
 * Fichier: AttachFieldElement.java
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
package fr.tech.sdx.xtogen.dom.elements;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.cocoon.components.request.multipart.FilePartFile;
import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;

import fr.tech.sdx.xtogen.dom.FieldElement;
import fr.tech.sdx.xtogen.dom.FieldValue;
import fr.tech.sdx.xtogen.util.ASCIIencoder;
import fr.tech.sdx.xtogen.util.FileHelper;

/**
 * @author Pierre Dittgen <a href="mailto:pierre.dittgen@pass-tech.fr"/>
 */
public class AttachFieldElement extends FieldElement
{
	// Logger
	private static final Logger LOG
		= Logger.getLogger(AttachFieldElement.class);

	private static final String WITNESS_SUFFIX	= ".tag";
	private static final String THUMB_SUFFIX	= ".thn";
	private static final String MIME_SUFFIX		= ".mime";
	private static final String DELETE_SUFFIX	= ".delete";
	private static final Pattern NUMBERED_REGEX = Pattern.compile("^(\\d+)_(.*)");
	
	private boolean _upload	= false;
	private File	_uploadDirectory = null;
	
	/**
	 * Constructor
	 * @param name Field name
	 * @param path Field path
	 */
	public AttachFieldElement(String name, String path)
	{
		super(name, path);
	}

	/**
	 * Extract values
	 * @param name Field name
	 * @param request Servlet request
	 */
	public final void extractValues(String name, Request request)
	{
		String[] deletes = getValues(request, name, DELETE_SUFFIX);
		Set deleteSet = new HashSet();
		for (int i=0; i<deletes.length; i++)
			deleteSet.add(deletes[i]);

		manageNormalValues(name, request, deleteSet);
		if (_upload)
			manageUploadedValue(name, request);
	}

	/**
	 * Manage upload file
	 * @param name Field name
	 * @param request Cocoon request
	 */
	private void manageUploadedValue(String name, Request request)
	{
		FilePartFile fpf = getUploadFile(request, name);
		if (fpf == null)
			return;
		File uploadedFile = fpf.getFile();
		LOG.debug("Uploaded file = [" + uploadedFile + "]");
		if (!uploadedFile.exists())
		{
			LOG.warn("Uploaded file doesn't exist");
			return;
		}
		if (uploadedFile.length() == 0L)
		{
			LOG.warn("Uploaded file is empty");
			uploadedFile.delete();
			return;
		}
		
		String filename = ASCIIencoder.removeAccents(
			new File(getUploadFileName(request, name)).getName());
		LOG.debug("Upload field = " + getUploadFileName(request, name));
		File attachFile = computeAttachFilename(filename);
		
		try
		{
			LOG.debug("Trying to copy " + uploadedFile + " to " + attachFile);
			FileHelper.copy(uploadedFile, attachFile);
		}
		catch (IOException ioe)
		{
			LOG.error("Can't copy file " + uploadedFile + " to file"
				+ attachFile);
			return;
		}
		uploadedFile.delete();
		FieldValue value = createFieldValue("attach/" + attachFile.getName());
		
		addValue(value);
	}

	/**
	 * @param filename Existing filename
	 * @return a filename that's still not used
	 */
	private File computeAttachFilename(String filename)
	{
		File f = new File(_uploadDirectory, filename);
		while (f.exists())
		{
			f = new File(_uploadDirectory, computeNextFilename(filename));
		}
		return f;
	}

	/**
	 * @param filename File name
	 * @return Next filename
	 */
	String computeNextFilename(String filename)
	{
		Matcher m = NUMBERED_REGEX.matcher(filename);
		if (m.matches())
		{
			long nb = 0;
			try
			{
				nb = Long.parseLong(m.group(1));
			}
			catch (NumberFormatException nfe)
			{
				LOG.warn("Can't increment so big number: " + m.group(1));
			}
			return (nb+1) + "_" + m.group(2);
		}
		
		return "1_" + filename;
	}

	/**
	 * Manages normal values
	 * @param name Field name
	 * @param request Cocoon request
	 * @param deleteSet Delete set
	 */
	private void manageNormalValues(String name, Request request, Set deleteSet)
	{
		String[] files = getValues(request, name);
		String[] witnesses = getValues(request, name, WITNESS_SUFFIX);
		String[] thumbs = getValues(request, name, THUMB_SUFFIX);
		String[] mimes = getValues(request, name, MIME_SUFFIX);
		String[] labels = getValues(request, name, LABEL_SUFFIX);

		for (int i=0; i<files.length; i++)
		{
			if ("".equals(files[i]))
				continue;
			FieldValue value = createFieldValue(files[i]);
			if (i < thumbs.length && !"".equals(thumbs[i]))
				value.addAttribute("thn", thumbs[i]);
			if (i < mimes.length && !"".equals(mimes[i]))
				value.addAttribute("mime-type", mimes[i]);
			if (i < labels.length && !"".equals(labels[i]))
				value.addAttribute("label", labels[i]);
			if (i < witnesses.length && deleteSet.contains(witnesses[i]))
				continue;
			addValue(value);
		}
	}

	/**
	 * Gets the list of attached files
	 * @return Attached files collection
	 */
	public Collection getAttachedFiles()
	{
		List attachedFiles = new ArrayList();
		for (Iterator it=getValues().iterator(); it.hasNext();)
		{
			FieldValue fv = (FieldValue)it.next();
			if (!"".equals(fv.getTextValue()))
				attachedFiles.add(fv.getTextValue());
			if (!"".equals(fv.getAttribute("thn")))
				attachedFiles.add(fv.getAttribute("thn"));
		}
		return attachedFiles;
	}

	/**
	 * @param b
	 */
	public void setUpload(boolean b, File uploadDirectory)
	{
		_upload = true;
		_uploadDirectory = uploadDirectory;
	}
}

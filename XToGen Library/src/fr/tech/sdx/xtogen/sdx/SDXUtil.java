/** 
 *  Fichier: SDXUtil.java
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
package fr.tech.sdx.xtogen.sdx;

import java.io.File;

import org.xml.sax.ContentHandler;

import fr.gouv.culture.sdx.application.Application;
import fr.gouv.culture.sdx.document.Document;
import fr.gouv.culture.sdx.document.IndexableDocument;
import fr.gouv.culture.sdx.document.XMLDocument;
import fr.gouv.culture.sdx.documentbase.DocumentBase;
import fr.gouv.culture.sdx.documentbase.IndexParameters;
import fr.gouv.culture.sdx.repository.Repository;

/**
 *
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public class SDXUtil
{
	private Document		_myDoc		= null;
	private DocumentBase	_sdxBase	= null;
	private Repository		_sdxRepo	= null;
	private IndexParameters	_sdxIndex	= null;
	
	/**
	 * Constructor
	 * @param docBase Document base
	 * @param sdx_application SDX application
	 * @throws Exception If something bad occurs
	 */
	public SDXUtil(String docBase, Application sdx_application)
		throws Exception
	{
		_myDoc		= new XMLDocument();
		_myDoc.setMimeType("text/xml");
		_sdxBase	= sdx_application.getDocumentBase(docBase);
		_sdxRepo	= _sdxBase.getRepository(null);
		_sdxIndex	= new IndexParameters();
	}
	
	/**
	 * Indexes a document found in a file
	 * @param docFile Document file
	 * @param docId Document id
	 * @param contentHandler contentHandler
	 * @throws Exception
	 */
	public void indexFile(File docFile, String docId, ContentHandler contentHandler)
		throws Exception
	{
		_myDoc.setId(docId);
		_myDoc.setContent(docFile);

		_sdxBase.index((IndexableDocument)_myDoc, _sdxRepo, _sdxIndex, contentHandler);
	}
}

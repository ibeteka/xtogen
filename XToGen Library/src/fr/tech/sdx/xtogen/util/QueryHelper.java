/** 
 *  Fichier: QueryHelper.java
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
package fr.tech.sdx.xtogen.util;

import java.io.IOException;

import fr.gouv.culture.sdx.application.Application;
import fr.gouv.culture.sdx.exception.SDXException;
import fr.gouv.culture.sdx.framework.FrameworkImpl;
import fr.gouv.culture.sdx.search.Searchable;
import fr.gouv.culture.sdx.search.lucene.query.FieldQuery;
import fr.gouv.culture.sdx.search.lucene.query.Index;
import fr.gouv.culture.sdx.search.lucene.query.Results;
import fr.gouv.culture.sdx.search.lucene.query.SearchLocations;
import fr.gouv.culture.sdx.search.lucene.query.SortSpecification;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public class QueryHelper
{
	/**
	 * Execute a field query on a base and return computed results
	 * @param sdxFrame SDX framework
	 * @param applicationId Application identifier
	 * @param baseId Base identifier
	 * @param fieldName Field name
	 * @param value Field value
	 * @return Computed results
	 * @throws SDXException If something bad occurs
	 * @throws IOException If something weird occurs
	 */
	public static Results fieldQuery(FrameworkImpl sdxFrame, String applicationId, String baseId, String fieldName, String value)
		throws SDXException, IOException
	{
		assert(sdxFrame != null);
		assert(applicationId != null && !"".equals(applicationId));
		assert(baseId != null && !"".equals(baseId));
		assert(fieldName != null && !"".equals(fieldName));
		assert(value != null && !"".equals(value));
		
		// Locations
		Application app = sdxFrame.getApplicationById(applicationId);
		Searchable searchable	= app.getSearchable(baseId);
		Index location = searchable.getIndex();
		SearchLocations locations	= new SearchLocations();
		locations.addIndex(location);
			
		// Query
		SortSpecification sortSpec = new SortSpecification();
		sortSpec.addSortKey(fieldName, locations);
		FieldQuery myQuery = new FieldQuery();

		// Execute query
		myQuery.setUp(locations, value, fieldName);
	
		// Manage results
		Results	myResults = (Results)myQuery.execute();
		myResults.reSort(sortSpec);
		return myResults;		
	}
}

/** 
 * Fichier: FieldType.java
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
 *	pierre.dittgen@pass-tech.fr
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
package fr.tech.sdx.xtogen.dom;

import fr.tech.sdx.xtogen.dom.elements.AttachFieldElement;
import fr.tech.sdx.xtogen.dom.elements.ChoiceFieldElement;
import fr.tech.sdx.xtogen.dom.elements.GroupFieldElement;
import fr.tech.sdx.xtogen.dom.elements.ModifiedFieldElement;
import fr.tech.sdx.xtogen.dom.elements.NormalFieldElement;
import fr.tech.sdx.xtogen.dom.elements.TextFieldElement;
import fr.tech.sdx.xtogen.dom.elements.WithLabelFieldElement;

/**
 * @author Pierre Dittgen
 *
 */
public abstract class FieldType 
{
	private String	_type = null;
	
	/** Attached document */
	public static final FieldType ATTACH	= new FieldType("attach")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new AttachFieldElement(name, path); }
	};
	
	/** Choice */
	public static final FieldType CHOICE	= new FieldType("choice")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new ChoiceFieldElement(name, path); }
	};
	
	/** Email */
	public static final FieldType EMAIL		= new FieldType("email")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new WithLabelFieldElement(name, path); }
	};
	
	/** Relation */
	public static final FieldType RELATION	= new FieldType("relation")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new NormalFieldElement(name, path); }
	};
	
	/** String */
	public static final FieldType STRING	= new FieldType("string")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new NormalFieldElement(name, path); }
	};
	
	/** Text */
	public static final FieldType TEXT		= new FieldType("text")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new TextFieldElement(name, path); }
	};
	
	/** Url */
	public static final FieldType URL		= new FieldType("url")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new WithLabelFieldElement(name, path); }
	};

	/** Modified */
	public static final FieldType MODIFIED	= new FieldType("modified")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new ModifiedFieldElement(name, path); }
	};
	
	/** Group */
	public static final FieldType GROUP		= new FieldType("group")
	{
		public FieldElement newFieldElement(String name, String path)
		{ return new GroupFieldElement(name, path); }	
	};
	
	/**
	 * Private constructor
	 */
	FieldType(String type)
	{
		if (type == null)
			throw new IllegalArgumentException("type is null");
		_type = type;
	}

	/**
	 * Creates a new field element
	 * @param name Field name
	 * @param path Field path
	 * @return The newly created Field element
	 */
	public abstract FieldElement newFieldElement(String name, String path);

	/**
	 * Tests the equality between two field types or a field type and a string
	 * @param o The object to test against
	 * @return true if the objects are equal
	 */
	public boolean equals(Object o)
	{
		if (o == this)	return true;
		if (o == null)	return false;
		if (o instanceof String && _type.equals((String)o)) return true;
		if (!(o instanceof FieldType)) return false;
		FieldType otherType = (FieldType)o;
		return otherType._type == _type;
	}
	
	/**
	 * @return Hash code
	 */
	public int hashCode()
	{
		return _type.hashCode();
	}
	
	/**
	 * For debugging purpose
	 * @return String version of the object
	 */
	public String toString()
	{
		return "FieldType('" + _type + "')";
	}

	/**
	 * How to get a type from a string
	 * @param type String describing a field type
	 * @return The right field type
	 */
	public static FieldType getType(String type)
	{
		if (GROUP.equals(type))		return GROUP;
		if (ATTACH.equals(type))	return ATTACH;
		if (CHOICE.equals(type))	return CHOICE;
		if (EMAIL.equals(type))		return EMAIL;
		if (RELATION.equals(type))	return RELATION;
		if (STRING.equals(type) || "".equals(type))	return STRING;
		if (TEXT.equals(type))		return TEXT;
		if (URL.equals(type))		return URL;
		if (MODIFIED.equals(type))	return MODIFIED;

		throw new IllegalArgumentException("Type de champ inconnu : <"
			+ type +">");
	}

}

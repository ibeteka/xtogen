/** 
 *  Fichier: FileType.java
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

import java.util.Properties;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public class FileType
{
	private static Properties MIMES = null;
	
	public FileType()
	{
	}
	
	/**
	 * Gets mime-type from extension
	 * @param extension File extension (without dot)
	 * @return Mime-type if found else null
	 */
	public static String getMimeFromExtension(String extension)
	{
		assert (extension != null);
		return getMimes().getProperty(extension.toLowerCase());
	}
		
	/**
	 * Gets mime properties, creates it if it is not initialized
	 * @return initialized mime map
	 */
	private static Properties getMimes()
	{	
		if (MIMES != null)
			return MIMES;
		
		MIMES = new Properties();
		MIMES.setProperty("323", "text/h323");
		MIMES.setProperty("ai", "application/postscript");
		MIMES.setProperty("aif", "audio/x-aiff");
		MIMES.setProperty("aifc", "audio/x-aiff");
		MIMES.setProperty("aiff", "audio/x-aiff");
		MIMES.setProperty("art", "image/x-jg");
		MIMES.setProperty("asc", "text/plain");
		MIMES.setProperty("asf", "video/x-ms-asf");
		MIMES.setProperty("asx", "video/x-ms-asf");
		MIMES.setProperty("au", "audio/basic");
		MIMES.setProperty("avi", "video/x-msvideo");
		MIMES.setProperty("bak", "application/x-trash");
		MIMES.setProperty("bat", "application/x-msdos-program");
		MIMES.setProperty("bcpio", "application/x-bcpio");
		MIMES.setProperty("bin", "application/octet-stream");
		MIMES.setProperty("bmp", "image/x-ms-bmp");
		MIMES.setProperty("book", "application/x-maker");
		MIMES.setProperty("c", "text/x-csrc");
		MIMES.setProperty("c++", "text/x-c++src");
		MIMES.setProperty("cat", "application/vnd.ms-pki.seccat");
		MIMES.setProperty("cc", "text/x-c++src");
		MIMES.setProperty("cdf", "application/x-cdf");
		MIMES.setProperty("cdr", "image/x-coreldraw");
		MIMES.setProperty("cdt", "image/x-coreldrawtemplate");
		MIMES.setProperty("cdy", "application/vnd.cinderella");
		MIMES.setProperty("chrt", "application/x-kchart");
		MIMES.setProperty("class", "application/x-java-vm");
		MIMES.setProperty("cls", "text/x-tex");
		MIMES.setProperty("com", "application/x-msdos-program");
		MIMES.setProperty("cpio", "application/x-cpio");
		MIMES.setProperty("cpp", "text/x-c++src");
		MIMES.setProperty("cpt", "image/x-corelphotopaint");
		MIMES.setProperty("crl", "application/x-pkcs7-crl");
		MIMES.setProperty("crt", "application/x-x509-ca-cert");
		MIMES.setProperty("csh", "text/x-csh");
		MIMES.setProperty("csm", "application/cu-seeme");
		MIMES.setProperty("css", "text/css");
		MIMES.setProperty("csv", "text/comma-separated-values");
		MIMES.setProperty("cu", "application/cu-seeme");
		MIMES.setProperty("cxx", "text/x-c++src");
		MIMES.setProperty("dcr", "application/x-director");
		MIMES.setProperty("deb", "application/x-debian-package");
		MIMES.setProperty("dif", "video/x-dv");
		MIMES.setProperty("diff", "text/plain");
		MIMES.setProperty("dir", "application/x-director");
		MIMES.setProperty("djv", "image/x-djvu");
		MIMES.setProperty("djvu", "image/x-djvu");
		MIMES.setProperty("dl", "video/dl");
		MIMES.setProperty("dll", "application/x-msdos-program");
		MIMES.setProperty("dms", "application/x-dms");
		MIMES.setProperty("doc", "application/msword");
		MIMES.setProperty("dot", "application/msword");
		MIMES.setProperty("dv", "video/x-dv");
		MIMES.setProperty("dvi", "application/x-dvi");
		MIMES.setProperty("dxr", "application/x-director");
		MIMES.setProperty("eps", "application/postscript");
		MIMES.setProperty("etx", "text/x-setext");
		MIMES.setProperty("exe", "application/x-msdos-program");
		MIMES.setProperty("ez", "application/andrew-inset");
		MIMES.setProperty("fb", "application/x-maker");
		MIMES.setProperty("fbdoc", "application/x-maker");
		MIMES.setProperty("fig", "application/x-xfig");
		MIMES.setProperty("fli", "video/fli");
		MIMES.setProperty("fm", "application/x-maker");
		MIMES.setProperty("frame", "application/x-maker");
		MIMES.setProperty("frm", "application/x-maker");
		MIMES.setProperty("gcf", "application/x-graphing-calculator");
		MIMES.setProperty("gf", "application/x-tex-gf");
		MIMES.setProperty("gif", "image/gif");
		MIMES.setProperty("gl", "video/gl");
		MIMES.setProperty("gnumeric", "application/x-gnumeric");
		MIMES.setProperty("gsf", "application/x-font");
		MIMES.setProperty("gsm", "audio/x-gsm");
		MIMES.setProperty("gtar", "application/x-gtar");
		MIMES.setProperty("h", "text/x-chdr");
		MIMES.setProperty("h++", "text/x-c++hdr");
		MIMES.setProperty("hdf", "application/x-hdf");
		MIMES.setProperty("hh", "text/x-c++hdr");
		MIMES.setProperty("hpp", "text/x-c++hdr");
		MIMES.setProperty("hqx", "application/mac-binhex40");
		MIMES.setProperty("hta", "application/hta");
		MIMES.setProperty("htm", "text/html");
		MIMES.setProperty("html", "text/html");
		MIMES.setProperty("hxx", "text/x-c++hdr");
		MIMES.setProperty("ica", "application/x-ica");
		MIMES.setProperty("ice", "x-conference/x-cooltalk");
		MIMES.setProperty("ief", "image/ief");
		MIMES.setProperty("iges", "model/iges");
		MIMES.setProperty("igs", "model/iges");
		MIMES.setProperty("iii", "application/x-iphone");
		MIMES.setProperty("ins", "application/x-internet-signup");
		MIMES.setProperty("isp", "application/x-internet-signup");
		MIMES.setProperty("jar", "application/x-java-archive");
		MIMES.setProperty("java", "text/x-java");
		MIMES.setProperty("jng", "image/x-jng");
		MIMES.setProperty("jnlp", "application/x-java-jnlp-file");
		MIMES.setProperty("jpe", "image/jpeg");
		MIMES.setProperty("jpeg", "image/jpeg");
		MIMES.setProperty("jpg", "image/jpeg");
		MIMES.setProperty("js", "application/x-javascript");
		MIMES.setProperty("kar", "audio/midi");
		MIMES.setProperty("kil", "application/x-killustrator");
		MIMES.setProperty("kpr", "application/x-kpresenter");
		MIMES.setProperty("kpt", "application/x-kpresenter");
		MIMES.setProperty("ksp", "application/x-kspread");
		MIMES.setProperty("kwd", "application/x-kword");
		MIMES.setProperty("kwt", "application/x-kword");
		MIMES.setProperty("latex", "application/x-latex");
		MIMES.setProperty("lha", "application/x-lha");
		MIMES.setProperty("lsf", "video/x-la-asf");
		MIMES.setProperty("lsx", "video/x-la-asf");
		MIMES.setProperty("ltx", "text/x-tex");
		MIMES.setProperty("lzh", "application/x-lzh");
		MIMES.setProperty("lzx", "application/x-lzx");
		MIMES.setProperty("m3u", "audio/x-mpegurl");
		MIMES.setProperty("maker", "application/x-maker");
		MIMES.setProperty("man", "application/x-troff-man");
		MIMES.setProperty("mdb", "application/msaccess");
		MIMES.setProperty("me", "application/x-troff-me");
		MIMES.setProperty("mesh", "model/mesh");
		MIMES.setProperty("mid", "audio/midi");
		MIMES.setProperty("midi", "audio/midi");
		MIMES.setProperty("mif", "application/x-mif");
		MIMES.setProperty("mml", "text/mathml");
		MIMES.setProperty("mng", "video/x-mng");
		MIMES.setProperty("moc", "text/x-moc");
		MIMES.setProperty("mov", "video/quicktime");
		MIMES.setProperty("movie", "video/x-sgi-movie");
		MIMES.setProperty("mp2", "audio/mpeg");
		MIMES.setProperty("mp3", "audio/mpeg");
		MIMES.setProperty("mpe", "video/mpeg");
		MIMES.setProperty("mpeg", "video/mpeg");
		MIMES.setProperty("mpega", "audio/mpeg");
		MIMES.setProperty("mpg", "video/mpeg");
		MIMES.setProperty("mpga", "audio/mpeg");
		MIMES.setProperty("ms", "application/x-troff-ms");
		MIMES.setProperty("msh", "model/mesh");
		MIMES.setProperty("msi", "application/x-msi");
		MIMES.setProperty("mxu", "video/vnd.mpegurl");
		MIMES.setProperty("nb", "application/mathematica");
		MIMES.setProperty("nc", "application/x-netcdf");
		MIMES.setProperty("o", "application/x-object");
		MIMES.setProperty("oda", "application/oda");
		MIMES.setProperty("ogg", "application/x-ogg");
		MIMES.setProperty("old", "application/x-trash");
		MIMES.setProperty("oza", "application/x-oz-application");
		MIMES.setProperty("p", "text/x-pascal");
		MIMES.setProperty("p7r", "application/x-pkcs7-certreqresp");
		MIMES.setProperty("pac", "application/x-ns-proxy-autoconfig");
		MIMES.setProperty("pas", "text/x-pascal");
		MIMES.setProperty("pat", "image/x-coreldrawpattern");
		MIMES.setProperty("pbm", "image/x-portable-bitmap");
		MIMES.setProperty("pcf", "application/x-font");
		MIMES.setProperty("pcf.Z", "application/x-font");
		MIMES.setProperty("pcx", "image/pcx");
		MIMES.setProperty("pdb", "chemical/x-pdb");
		MIMES.setProperty("pdf", "application/pdf");
		MIMES.setProperty("pfa", "application/x-font");
		MIMES.setProperty("pfb", "application/x-font");
		MIMES.setProperty("pgm", "image/x-portable-graymap");
		MIMES.setProperty("pgn", "application/x-chess-pgn");
		MIMES.setProperty("pgp", "application/pgp-signature");
		MIMES.setProperty("php", "application/x-httpd-php");
		MIMES.setProperty("php3", "application/x-httpd-php3");
		MIMES.setProperty("php3p", "application/x-httpd-php3-preprocessed");
		MIMES.setProperty("php4", "application/x-httpd-php4");
		MIMES.setProperty("phps", "application/x-httpd-php-source");
		MIMES.setProperty("pht", "application/x-httpd-php");
		MIMES.setProperty("phtml", "application/x-httpd-php");
		MIMES.setProperty("pk", "application/x-tex-pk");
		MIMES.setProperty("pl", "application/x-perl");
		MIMES.setProperty("pls", "audio/x-scpls");
		MIMES.setProperty("pm", "application/x-perl");
		MIMES.setProperty("png", "image/png");
		MIMES.setProperty("pnm", "image/x-portable-anymap");
		MIMES.setProperty("pot", "application/vnd.ms-powerpoint");
		MIMES.setProperty("ppm", "image/x-portable-pixmap");
		MIMES.setProperty("pps", "application/vnd.ms-powerpoint");
		MIMES.setProperty("ppt", "application/vnd.ms-powerpoint");
		MIMES.setProperty("prf", "application/pics-rules");
		MIMES.setProperty("ps", "application/postscript");
		MIMES.setProperty("psd", "image/x-photoshop");
		MIMES.setProperty("qt", "video/quicktime");
		MIMES.setProperty("qtl", "application/x-quicktimeplayer");
		MIMES.setProperty("ra", "audio/x-realaudio");
		MIMES.setProperty("ram", "audio/x-pn-realaudio");
		MIMES.setProperty("ras", "image/x-cmu-raster");
		MIMES.setProperty("rgb", "image/x-rgb");
		MIMES.setProperty("rm", "audio/x-pn-realaudio");
		MIMES.setProperty("roff", "application/x-troff");
		MIMES.setProperty("rpm", "audio/x-pn-realaudio-plugin");
		MIMES.setProperty("rtf", "text/rtf");
		MIMES.setProperty("rtx", "text/richtext");
		MIMES.setProperty("sct", "text/scriptlet");
		MIMES.setProperty("sd2", "audio/x-sd2");
		MIMES.setProperty("sda", "application/vnd.stardivision.draw");
		MIMES.setProperty("sdc", "application/vnd.stardivision.calc");
		MIMES.setProperty("sdd", "application/vnd.stardivision.impress");
		MIMES.setProperty("sdp", "application/vnd.stardivision.impress");
		MIMES.setProperty("sdw", "application/vnd.stardivision.writer");
		MIMES.setProperty("ser", "application/x-java-serialized-object");
		MIMES.setProperty("sgl", "application/vnd.stardivision.writer-global");
		MIMES.setProperty("sh", "text/x-sh");
		MIMES.setProperty("shar", "application/x-shar");
		MIMES.setProperty("shtml", "text/x-server-parsed-html");
		MIMES.setProperty("sid", "audio/prs.sid");
		MIMES.setProperty("sik", "application/x-trash");
		MIMES.setProperty("silo", "model/mesh");
		MIMES.setProperty("sit", "application/x-stuffit");
		MIMES.setProperty("skd", "application/x-koan");
		MIMES.setProperty("skm", "application/x-koan");
		MIMES.setProperty("skp", "application/x-koan");
		MIMES.setProperty("skt", "application/x-koan");
		MIMES.setProperty("smf", "application/vnd.stardivision.math");
		MIMES.setProperty("smi", "application/smil");
		MIMES.setProperty("smil", "application/smil");
		MIMES.setProperty("snd", "audio/basic");
		MIMES.setProperty("spl", "application/x-futuresplash");
		MIMES.setProperty("src", "application/x-wais-source");
		MIMES.setProperty("stc", "application/vnd.sun.xml.calc.template");
		MIMES.setProperty("std", "application/vnd.sun.xml.draw.template");
		MIMES.setProperty("sti", "application/vnd.sun.xml.impress.template");
		MIMES.setProperty("stl", "application/vnd.ms-pki.stl");
		MIMES.setProperty("stw", "application/vnd.sun.xml.writer.template");
		MIMES.setProperty("sty", "text/x-tex");
		MIMES.setProperty("sv4cpio", "application/x-sv4cpio");
		MIMES.setProperty("sv4crc", "application/x-sv4crc");
		MIMES.setProperty("svg", "image/svg+xml");
		MIMES.setProperty("svgz", "image/svg+xml");
		MIMES.setProperty("swf", "application/x-shockwave-flash");
		MIMES.setProperty("swfl", "application/x-shockwave-flash");
		MIMES.setProperty("sxc", "application/vnd.sun.xml.calc");
		MIMES.setProperty("sxd", "application/vnd.sun.xml.draw");
		MIMES.setProperty("sxg", "application/vnd.sun.xml.writer.global");
		MIMES.setProperty("sxi", "application/vnd.sun.xml.impress");
		MIMES.setProperty("sxm", "application/vnd.sun.xml.math");
		MIMES.setProperty("sxw", "application/vnd.sun.xml.writer");
		MIMES.setProperty("t", "application/x-troff");
		MIMES.setProperty("tar", "application/x-tar");
		MIMES.setProperty("taz", "application/x-gtar");
		MIMES.setProperty("tcl", "text/x-tcl");
		MIMES.setProperty("tex", "text/x-tex");
		MIMES.setProperty("texi", "application/x-texinfo");
		MIMES.setProperty("texinfo", "application/x-texinfo");
		MIMES.setProperty("text", "text/plain");
		MIMES.setProperty("tgz", "application/x-gtar");
		MIMES.setProperty("tif", "image/tiff");
		MIMES.setProperty("tiff", "image/tiff");
		MIMES.setProperty("tk", "text/x-tcl");
		MIMES.setProperty("tm", "text/texmacs");
		MIMES.setProperty("tr", "application/x-troff");
		MIMES.setProperty("ts", "text/texmacs");
		MIMES.setProperty("tsp", "application/dsptype");
		MIMES.setProperty("tsv", "text/tab-separated-values");
		MIMES.setProperty("txt", "text/plain");
		MIMES.setProperty("uls", "text/iuls");
		MIMES.setProperty("ustar", "application/x-ustar");
		MIMES.setProperty("vcd", "application/x-cdlink");
		MIMES.setProperty("vcf", "text/x-vcard");
		MIMES.setProperty("vcs", "text/x-vcalendar");
		MIMES.setProperty("vor", "application/vnd.stardivision.writer");
		MIMES.setProperty("vrm", "x-world/x-vrml");
		MIMES.setProperty("vrml", "x-world/x-vrml");
		MIMES.setProperty("wad", "application/x-doom");
		MIMES.setProperty("wav", "audio/x-wav");
		MIMES.setProperty("wax", "audio/x-ms-wax");
		MIMES.setProperty("wbmp", "image/vnd.wap.wbmp");
		MIMES.setProperty("wbxml", "application/vnd.wap.wbxml");
		MIMES.setProperty("wk", "application/x-123");
		MIMES.setProperty("wm", "video/x-ms-wm");
		MIMES.setProperty("wma", "audio/x-ms-wma");
		MIMES.setProperty("wmd", "application/x-ms-wmd");
		MIMES.setProperty("wml", "text/vnd.wap.wml");
		MIMES.setProperty("wmlc", "application/vnd.wap.wmlc");
		MIMES.setProperty("wmls", "text/vnd.wap.wmlscript");
		MIMES.setProperty("wmlsc", "application/vnd.wap.wmlscriptc");
		MIMES.setProperty("wmv", "video/x-ms-wmv");
		MIMES.setProperty("wmx", "video/x-ms-wmx");
		MIMES.setProperty("wmz", "application/x-ms-wmz");
		MIMES.setProperty("wp5", "application/wordperfect5.1");
		MIMES.setProperty("wrl", "x-world/x-vrml");
		MIMES.setProperty("wsc", "text/scriptlet");
		MIMES.setProperty("wvx", "video/x-ms-wvx");
		MIMES.setProperty("wz", "application/x-wingz");
		MIMES.setProperty("xbm", "image/x-xbitmap");
		MIMES.setProperty("xht", "application/xhtml+xml");
		MIMES.setProperty("xhtml", "application/xhtml+xml");
		MIMES.setProperty("xlb", "application/vnd.ms-excel");
		MIMES.setProperty("xls", "application/vnd.ms-excel");
		MIMES.setProperty("xml", "text/xml");
		MIMES.setProperty("xpm", "image/x-xpixmap");
		MIMES.setProperty("xsl", "text/xml");
		MIMES.setProperty("xwd", "image/x-xwindowdump");
		MIMES.setProperty("xyz", "chemical/x-xyz");
		MIMES.setProperty("zip", "application/zip");
		MIMES.setProperty("~", "application/x-trash");
		return MIMES;
	}
}

/** 
 *  Fichier: TimeTracker.java
 * 
 *	XtoGen - G�n�rateur d'applications SDX2
 * 	Copyright (C) 2003 Minist�re de la culture et de la communication, PASS Technologie
 *
 *	Minist�re de la culture et de la communication,
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
 *	License", tels que publi�s par la "Free Software Foundation"; soit
 *	la version 2 de cette licence ou (� votre choix) toute version
 *	ult�ieure.
 *
 *	Ce programme est distribu� dans l'espoir qu'il sera utile, mais
 *	SANS AUCUNE GARANTIE, ni explicite ni implicite; sans m�me les
 *	garanties de commercialisation ou d'adaptation dans un but sp�cifique.
 *
 *	Se r�f�rer � la "GNU General Public License" pour plus de d�tails.
 *
 *	Vous devriez avoir re�u une copie de la "GNU General Public License"
 *	en m�me temps que ce programme; sinon, �crivez � la "Free Software
 *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
 */
package fr.tech.sdx.xtogen.util;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public class TimeTracker
{
	private HashMap _timers = new HashMap();
	
	public TimeTracker()
	{
	}
	
	public void start(String timerName)
	{
		Chrono timer = null;
		if (_timers.containsKey(timerName))
			 timer = (Chrono)_timers.get(timerName);
		else timer = new Chrono();
		timer.reset();
		_timers.put(timerName, timer);
	}
	
	public void stop(String timerName)
	{
		if (!_timers.containsKey(timerName))
		{
			System.err.println("Timer " + timerName + " not started");
			return;
		}
		
		((Chrono)_timers.get(timerName)).stop();
	}
	
	public void print()
	{
		for (Iterator it=_timers.keySet().iterator(); it.hasNext();)
		{
			String timerName = (String)it.next();
			long timerDelay = ((Chrono)_timers.get(timerName)).getElapsedTime();
			System.err.println(timerName + "\t= " + timerDelay + "ms");
		}
	}

	private static class Chrono
	{
		private long _startTime = getTime();
		private long _elapsedTime = 0L;
		
		public void reset()
		{
			_startTime = getTime();
		}
		
		public void stop()
		{
			_elapsedTime += (getTime() - _startTime); 
		}
		
		private long getTime()
		{
			return new Date().getTime();
		}
		
		private long getElapsedTime()
		{
			return _elapsedTime;
		}
	}
}

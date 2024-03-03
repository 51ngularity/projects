


-- 1) gib für ein Datum die GesamtArbeitszeit für alle Mitarbeiter aus
select 
	m.idMitarbeiter, 
    m.Vorname, m.Nachname, 
    m.Stellenbezeichnung,
    mhs.SchichtDatum,
    s.SchichtBezeichnung, 
    timediff( mhs.RealSchichtEnde , mhs.RealSchichtStart ) HeuteGearbeitet    
from krankenhaus.mitarbeiter_has_schichtt mhs
	join krankenhaus.schicht s on s.idSchicht = mhs.Schichtt_idSchicht
	join krankenhaus.mitarbeiter m on m.idMitarbeiter = mhs.Mitarbeiter_idMitarbeiter
where mhs.SchichtDatum = '2023-09-04 00:00:00'
;


-- 2) gib für ein Datum die Höhe der Verspätung für alle Mitarbeiter aus
select m.idMitarbeiter, 
    m.Vorname, m.Nachname, 
    m.Stellenbezeichnung,
    addtime(mhs.SchichtDatum , s.SchichtStart) geplanterSchichtStart,
    mhs.RealSchichtStart, 
    timediff( mhs.SchichtDatum + s.SchichtStart , mhs.RealSchichtStart ) Verspaetung
from krankenhaus.mitarbeiter_has_schichtt mhs
	join krankenhaus.schicht s on s.idSchicht = mhs.Schichtt_idSchicht
	join krankenhaus.mitarbeiter m on m.idMitarbeiter = mhs.Mitarbeiter_idMitarbeiter
where mhs.SchichtDatum = '2023-09-04 00:00:00'
;


-- 3)  gib für ein Datum die Höhe der Überstunden für alle Mitarbeiter aus
select m.idMitarbeiter, 
    m.Vorname, m.Nachname, 
    m.Stellenbezeichnung,
    addtime(mhs.SchichtDatum , s.SchichtStart + s.SchichtDauer) geplantesSchichtende,
    mhs.RealSchichtEnde realesSchichtende,
	timediff( mhs.RealSchichtEnde , mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer ) Ueberstunden
from krankenhaus.mitarbeiter_has_schichtt mhs
	join krankenhaus.schicht s on s.idSchicht = mhs.Schichtt_idSchicht
	join krankenhaus.mitarbeiter m on m.idMitarbeiter = mhs.Mitarbeiter_idMitarbeiter 
where mhs.SchichtDatum = '2023-09-04 00:00:00'
;


-- 4) gib für ein Datum und einen Mitarbeiter das Gehalt für diesen Tag aus
select 
	m.idMitarbeiter, 
    m.Vorname, m.Nachname, 
    m.Stellenbezeichnung,
    m.Stundenlohn,
    m.Ueberstundenzulage,
    mhs.RealSchichtStart,
    addtime(mhs.SchichtDatum , s.SchichtStart + s.SchichtDauer) PlanSchichtEnde,
    mhs.RealSchichtEnde,
	hour(timediff( mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer , mhs.RealSchichtStart )) +
		minute(timediff( mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer , mhs.RealSchichtStart )) / 60  regulaereArbStunden,
	(hour(timediff( mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer , mhs.RealSchichtStart )) +
		minute(timediff( mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer , mhs.RealSchichtStart )) / 60  
        ) * m.Stundenlohn GeldFuerRegArbeit ,
    hour(timediff( mhs.RealSchichtEnde , mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer )) +
    minute(timediff( mhs.RealSchichtEnde , mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer )) / 60 Ueberstunden,
    if(
		mhs.RealSchichtEnde > addtime(mhs.SchichtDatum , s.SchichtStart + s.SchichtDauer) ,  -- if RealSchichtEnde > regulaerSchichtEnde
        (hour(timediff( mhs.RealSchichtEnde , mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer )) + 
        minute(timediff( mhs.RealSchichtEnde , mhs.SchichtDatum + s.SchichtStart + s.SchichtDauer )) / 60 ) * m.Stundenlohn * m.Ueberstundenzulage , 
        null
        ) GeldFuerUeberstunden
from krankenhaus.mitarbeiter_has_schichtt mhs
	join krankenhaus.schicht s on s.idSchicht = mhs.Schichtt_idSchicht
	join krankenhaus.mitarbeiter m on m.idMitarbeiter = mhs.Mitarbeiter_idMitarbeiter 
where mhs.SchichtDatum = '2023-09-04 00:00:00' and m.idMitarbeiter = 3
;


-- 4) verkuerzt
-- gib für ein Datum und einen Mitarbeiter das Gehalt für diesen Tag aus
select
	idMitarbeiter, 
    Vorname, 
    Nachname, 
    Stellenbezeichnung,
    Stundenlohn,
    Ueberstundenzulage,
    RealSchichtStart,
    PlanSchichtEnde,
    RealSchichtEnde,
    regulaereArbStunden,
    round( GeldFuerRegArbeit, 2 ) GeldFuerRegArbeit,
    Ueberstunden,
    round( GeldFuerUeberstunden, 2 ) GeldFuerUeberstunden,
    round( (GeldFuerRegArbeit + GeldFuerUeberstunden), 2 ) GeldInsgesamt
from
	(select
		*,
		(t2.regulaereArbStunden * t2.Stundenlohn) GeldFuerRegArbeit,
        if(
			t2.RealSchichtEnde > t2.PlanSchichtEnde,  -- if anzahl Ueberstunden > 0
			t2.Ueberstunden * t2.Stundenlohn * t2.Ueberstundenzulage, 
			null
        ) GeldFuerUeberstunden
	from
		(select 
			*, 
			hour(timediff( t1.PlanSchichtEnde , t1.RealSchichtStart )) +
				minute(timediff( t1.PlanSchichtEnde , t1.RealSchichtStart )) / 60  regulaereArbStunden,
			hour(timediff( t1.RealSchichtEnde , t1.PlanSchichtEnde )) +
				minute(timediff( t1.RealSchichtEnde , t1.PlanSchichtEnde )) / 60 Ueberstunden
		from
			(select 
				*, 
                addtime(mhs.SchichtDatum , s.SchichtStart + s.SchichtDauer) PlanSchichtEnde
			from krankenhaus.mitarbeiter_has_schichtt mhs
				join krankenhaus.schicht s on s.idSchicht = mhs.Schichtt_idSchicht
				join krankenhaus.mitarbeiter m on m.idMitarbeiter = mhs.Mitarbeiter_idMitarbeiter 
			where mhs.SchichtDatum = '2023-09-04 00:00:00' and m.idMitarbeiter = 3
			) t1 
		) t2
	) t3
;


-- 5) gib für ein Datum und einen Mitarbeiter die Auslastung für diesen Tag aus
--  = summe(mit aufgaben verbrachte zeit) / gesamtArbeitszeit
select 
	m.idMitarbeiter,
    m.Vorname, m.Nachname, 
    m.Stellenbezeichnung,
    mhs.SchichtDatum,
    s.SchichtBezeichnung, 
    timediff( mhs.RealSchichtEnde , mhs.RealSchichtStart ) HeuteGearbeitet,
	time(sum(t.Dauer)) ZeitInAufgaben,
    round( time_to_sec(sum(t.Dauer)) / time_to_sec(mhs.RealSchichtEnde - mhs.RealSchichtStart), 2 ) `% der Zeit gearbeitet`
from krankenhaus.mitarbeiter_has_schichtt mhs
	join krankenhaus.schicht s on s.idSchicht = mhs.Schichtt_idSchicht
	join krankenhaus.mitarbeiter m on m.idMitarbeiter = mhs.Mitarbeiter_idMitarbeiter
	join krankenhaus.aufgabenplan_has_mitarbeiter ahm on ahm.Mitarbeiter_idMitarbeiter = m.idMitarbeiter
	join krankenhaus.aufgabenplan a on a.idAufgabenplan = ahm.Aufgabenplan_idAufgabenplan
    join krankenhaus.taetigkeit t on t.idTaetigkeit = a.Taetigkeit_idTaetigkeit
where date(a.AufgabenStart) = '2023-09-04' and m.idMitarbeiter = 4
group by m.idMitarbeiter
;


-- 6) gib für ein Datum den verzeichneten und realen Lagerbestand aller Chemikalien aus, die (seit der letzten Zählung) in Aufgaben involviert waren
select 
	c.idChemikalie,
	c.ChemikalienArt,
    c.MengeImLager verzeichneterBestand,
    c.Einheit,
    t.TaetigkeitenBezeichnung,
    count(*) wieOftDurchgeführt,
    sum(tbc.Menge) verbraucht,
    tbc.Einheit,
    c.MengeImLager - sum(tbc.Menge) realerBestand,
    c.Einheit
from krankenhaus.chemikalie c
	join krankenhaus.taetigkeit_braucht_chemikalie tbc on c.idChemikalie = tbc.Chemikalie_idChemikalie
	join krankenhaus.taetigkeit t on t.idTaetigkeit = tbc.Taetigkeit_idTaetigkeit
	join krankenhaus.aufgabenplan a on a.Taetigkeit_idTaetigkeit = t.idTaetigkeit
where a.AufgabenStart > c.Datum    -- alle aufgaben, die nach dem letzten zählDatum verrichtet worden sind
group by c.idChemikalie
;


-- 7) gib für ein Datum den verzeichneten Lagerbestand aller Chemikalien aus, die (seit der letzten Zählung) nicht in Aufgaben involviert waren
select 
	c1.idChemikalie,
	c1.ChemikalienArt,
    c1.MengeImLager verzeichneterBestand,
    c1.Einheit
from
	krankenhaus.chemikalie c1
    left join
		(select c.idChemikalie
		from krankenhaus.chemikalie c
			join krankenhaus.taetigkeit_braucht_chemikalie tbc on c.idChemikalie = tbc.Chemikalie_idChemikalie
			join krankenhaus.taetigkeit t on t.idTaetigkeit = tbc.Taetigkeit_idTaetigkeit
			join krankenhaus.aufgabenplan a on a.Taetigkeit_idTaetigkeit = t.idTaetigkeit
		where a.AufgabenStart > c.Datum    -- alle aufgaben, die nach dem letzten zählDatum verrichtet worden sind
		group by c.idChemikalie
        ) t1 on c1.idChemikalie = t1.idChemikalie 
where t1.idChemikalie is null
;


-- 8) gib für ein Datum alle Patienten aus, die an diesem Tag behandelt worden sind
select 
	p.idPatient,
	p.Vorname,
    p.Nachname,
	count(*) AnzahlBehandlungen
from
	krankenhaus.patient p
    join krankenhaus.aufgabenplan_has_patient ahp on p.idPatient = ahp.Patient_idPatient
    join krankenhaus.aufgabenplan a on a.idAufgabenplan = ahp.Aufgabenplan_idAufgabenplan
where date(a.AufgabenStart) = '2023-09-04'
group by p.idPatient
;


-- 9) gib für ein Datum und einen Patienten alle Behandlungen aus, die er an diesem Tag bekommen hat
select
	p.idPatient,
	p.Vorname,
    p.Nachname,
    time(a.AufgabenStart) von,
    time(a.AufgabenEnde) bis,
    t.TaetigkeitenBezeichnung Bahandlung
from
	krankenhaus.patient p
    join krankenhaus.aufgabenplan_has_patient ahp on p.idPatient = ahp.Patient_idPatient
    join krankenhaus.aufgabenplan a on a.idAufgabenplan = ahp.Aufgabenplan_idAufgabenplan
    join krankenhaus.taetigkeit t on t.idTaetigkeit = a.Taetigkeit_idTaetigkeit
where p.idPatient = 3 and date(a.AufgabenStart) = '2023-09-04'
order by a.AufgabenStart
;


-- 10) schreibe für ein Datum und einen Patienten eine Rechnung
select 
	p.idPatient,
	p.Vorname,
    p.Nachname,
    time(a.AufgabenStart) Behandlungsbeginn,
    t.TaetigkeitenBezeichnung Bahandlung,
    a.AufgabenStart Datum,
    t.Preis,
    (select sum(t.Preis)
	from
		krankenhaus.patient p
		join krankenhaus.aufgabenplan_has_patient ahp on p.idPatient = ahp.Patient_idPatient
		join krankenhaus.aufgabenplan a on a.idAufgabenplan = ahp.Aufgabenplan_idAufgabenplan
		join krankenhaus.taetigkeit t on t.idTaetigkeit = a.Taetigkeit_idTaetigkeit
	where p.idPatient = 3 and date(a.AufgabenStart) = '2023-09-04'
	group by p.idPatient) GesamtPreis
from
	krankenhaus.patient p
    join krankenhaus.aufgabenplan_has_patient ahp on p.idPatient = ahp.Patient_idPatient
    join krankenhaus.aufgabenplan a on a.idAufgabenplan = ahp.Aufgabenplan_idAufgabenplan
    join krankenhaus.taetigkeit t on t.idTaetigkeit = a.Taetigkeit_idTaetigkeit
where p.idPatient = 3 and date(a.AufgabenStart) = '2023-09-04'
order by a.AufgabenStart
;


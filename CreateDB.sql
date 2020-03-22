/**
 * Autor of this SQL-Script
 * Jens Fischer (fischer843@gmail.com)
 * 
 * Version 0.1  / 22.03.2010 at 18:30
 * 		First check-in 
 * 
 * Version 0.2  / 22.03.2010 at 19:30
 * 		- Add comment how to install extenstion  "uuid-ossp"
 * 		- Replace wrong datatype NULL into UUID
 */



/**
 * The "uuid-ossp" library enables you to generate UUID values server-side in Postgres.
 * http://www.postgresql.org/docs/current/static/uuid-ossp.html
 *
 * The technique to install this library changed as of Postgres 9.1, because of the new Extension feature.
 * Installing and uninstalling are now easier. I have an overview on my blog, but I'm posting the brief steps 
 * here for posterity.
 *
 *
 *
 * To see what extensions are already installed in your Postgres, run this SQL:
 * select * from pg_extension;
 *
 *
 * To see if the "uuid-ossp" extension is available, run this SQL:
 * select * from pg_available_extensions;
 *
 *****************************************************************************************************************
 * To install/load the extension "uuid-ossp", run this SQL:
 * CREATE EXTENSION "uuid-ossp";
 *****************************************************************************************************************
 */


------------------------------------------
-- Bestehende Datenbankstruktur löschen -- 
------------------------------------------

ALTER TABLE "public"."driver2tour" DROP CONSTRAINT "driver2tour_pkey_driver_fkey";

ALTER TABLE "public"."formtemplatefield" DROP CONSTRAINT "formtemplatefield_name_fkey";

ALTER TABLE "public"."formtemplatefield" DROP CONSTRAINT "formtemplatefield_pkey_formtemplate_fkey";

ALTER TABLE "public"."driver2tour" DROP CONSTRAINT "driver2tour_pkey_carregistration_fkey";

ALTER TABLE "public"."tour2border" DROP CONSTRAINT "tour2border_pkey_border_fkey";

ALTER TABLE "public"."driver2company" DROP CONSTRAINT "driver2company_company_id_fkey";

ALTER TABLE "public"."border" DROP CONSTRAINT "border_ridefrom_fkey";

ALTER TABLE "public"."formtemplate" DROP CONSTRAINT "formtemplate_pkey_border_fkey";

ALTER TABLE "public"."formfield_value" DROP CONSTRAINT "formfield_value_pkey_tour_fkey";

ALTER TABLE "public"."formtemplate" DROP CONSTRAINT "formtemplate_name_fkey";

ALTER TABLE "public"."driver2tour" DROP CONSTRAINT "driver2tour_pkey_tour_fkey";

ALTER TABLE "public"."border" DROP CONSTRAINT "border_rideto_fkey";

ALTER TABLE "public"."formfield_value" DROP CONSTRAINT "formfield_value_pkey_formtemplatefield_fkey";

ALTER TABLE "public"."tour2border" DROP CONSTRAINT "tour2border_pkey_tour_fkey";

ALTER TABLE "public"."healthcheck" DROP CONSTRAINT "healthcheck_pkey_driver_fkey";

ALTER TABLE "public"."healthcheck" DROP CONSTRAINT "healthcheck_pkey_guard_fkey";

ALTER TABLE "public"."carregistration" DROP CONSTRAINT "carregistration_pkey_company_fkey";

ALTER TABLE "public"."driver2company" DROP CONSTRAINT "driver2company_driver_id_fkey";

ALTER TABLE "public"."formtemplate" DROP CONSTRAINT "pkey_formtemplate";

ALTER TABLE "public"."driver2company" DROP CONSTRAINT "pkey_driver2company";

ALTER TABLE "public"."carregistration" DROP CONSTRAINT "pkey_carregistration";

ALTER TABLE "public"."border" DROP CONSTRAINT "pkey_border";

ALTER TABLE "public"."guard" DROP CONSTRAINT "pkey_guard";

ALTER TABLE "public"."tour" DROP CONSTRAINT "pkey_tour";

ALTER TABLE "public"."driver2tour" DROP CONSTRAINT "pkey_driver2tour";

ALTER TABLE "public"."company" DROP CONSTRAINT "pkey_company";

ALTER TABLE "public"."formfield_value" DROP CONSTRAINT "pkey_formfield_value";

ALTER TABLE "public"."healthcheck" DROP CONSTRAINT "pkey_healthcheck";

ALTER TABLE "public"."migration_versions" DROP CONSTRAINT "migration_versions_pkey";

ALTER TABLE "public"."country" DROP CONSTRAINT "pkey_country";

ALTER TABLE "public"."formtemplatefield" DROP CONSTRAINT "pkey_formtemplatefield";

ALTER TABLE "public"."tour2border" DROP CONSTRAINT "pkey_tour2border";

ALTER TABLE "public"."driver" DROP CONSTRAINT "pkey_driver";

DROP INDEX "public"."pkey_tour";

DROP INDEX "public"."pkey_formtemplate";

DROP INDEX "public"."pkey_tour2border";

DROP INDEX "public"."pkey_company";

DROP INDEX "public"."pkey_driver2company";

DROP INDEX "public"."migration_versions_pkey";

DROP INDEX "public"."pkey_formtemplatefield";

DROP INDEX "public"."pkey_border";

DROP INDEX "public"."pkey_driver2tour";

DROP INDEX "public"."pkey_carregistration";

DROP INDEX "public"."pkey_country";

DROP INDEX "public"."pkey_healthcheck";

DROP INDEX "public"."pkey_formfield_value";

DROP INDEX "public"."pkey_guard";

DROP INDEX "public"."pkey_driver";

DROP TABLE "public"."guard";

DROP TABLE "public"."formtemplatefield";

DROP TABLE "public"."tour2border";

DROP TABLE "public"."carregistration";

DROP TABLE "public"."formfield_value";

DROP TABLE "public"."formtemplate";

DROP TABLE "public"."border";

DROP TABLE "public"."healthcheck";

DROP TABLE "public"."driver";

DROP TABLE "public"."company";

DROP TABLE "public"."driver2company";

DROP TABLE "public"."driver2tour";

DROP TABLE "public"."migration_versions";

DROP TABLE "public"."tour";

DROP TABLE "public"."country";


------------------------------------------
-- Bestehende Datenbankstruktur löschen -- 
------------------------------------------




------------------------------------------
-- Datenbankstruktur: Tabellen anlegen  -- 
------------------------------------------

/*****************************************
Tabellen: guard

In dieser Tabelle werden die Beamten
an der Grenze erfasst. Diese Tabelle 
ist SEHR VORSICHTIG und mit SEHR
BEGRENZTER Zugriffsberechtigungen
zu versehen. Auschliesslich das Feld
pkey (UUID) darf nach draussen gelangen.

Die Beamten-Daten müssen geschützt sein
*****************************************/

CREATE TABLE "public"."guard" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"firstname" VARCHAR(255),
		"lastname" VARCHAR(255),
		"street" VARCHAR(255),
		"place" VARCHAR(255),
		"country" VARCHAR(255),
		"email" VARCHAR(255),
		"mobile" VARCHAR(255),
		"birthday" DATE,
		"passportid" VARCHAR(255)
	);


	

/*****************************************
Tabellen: formtemplatefield

In dieser Tabelle werden die auszu-
füllenden Felder der einzelnen Formulare
[formtemplate] erfasst. 

Im Feld [name] sollte die Bezeichnung vom
Formularfeld genutzt werden

Im Feld [pkey_formtemplate] wird bestimmt 
zu welchem FormularTemplate das Field ge-
hört. Das Feld kann aktuell nur einem be-
stimmten FormularTemplate zugewisen werden.

Mit Feld [pos] sollte die Reihenfolge, in der
die Felder im GUI angezeigt werden, festge-
legt werden. Im Optiomalfall ist es deckungs-
gleich mit der Reihenfolge im orginal 
Formular,


*****************************************/
	
CREATE TABLE "public"."formtemplatefield" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"name" VARCHAR(255) NOT NULL,
		"pkey_formtemplate" UUID NOT NULL,
 		"datatype" VARCHAR(255) NOT NULL,
		"pos" INT4
	);


	
/*****************************************
Tabellen: tour2border

In dieser Tabelle wird die Tour
und die damit verbunden Grenze erfasst.

Mit Feld [approvedbyguard] wird der Grenzbeamte,
der die Kontrolle gemacht hinterlegt.

Mit Feld [approvedOn] wird das Datum,
an dem die Kontrolle gemacht wurde, hinterlegt.

Mit Feld [transiton] wird das Datum,
an dem der Fahrer den transit vollzogen hat,
hinterlegt.


Der Beamte kann Abend auf dem Rasthof bereits 
die Kontrolle der Papiere durchführen und
vermerken. Am nächsten Morgen findet dann 
aber erst der transit statt. Aus diesem Grunde
gibt es zwei unterschiedliche Datumsfelder.


******************************************/

CREATE TABLE "public"."tour2border" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"pkey_tour" UUID NOT NULL,
		"pkey_border" UUID NOT NULL,
		"approvedbyguard" UUID null,
		"approvedon" DATE,
		"transiton" DATE
	);



/*****************************************
Tabellen: carregistration

In dieser Tabelle wird das Fahrzeug anhand
seinnes KFZ-Kennzeichens einer Firma zu-
geordnet.

******************************************/
	
CREATE TABLE "public"."carregistration" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"carregistration" VARCHAR(255),
		"pkey_company" UUID
	);



/*****************************************
Tabellen: formfield_value

In dieser Tabelle werden die konkreten Angaben
des Fahrer bezogen auf das Formular hinterlegt.

Diese werden auch zum generieren des "Passier-"
"scheins" verwendet.


******************************************/
	
CREATE TABLE "public"."formfield_value" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"pkey_tour" UUID NOT NULL,
		"pkey_formtemplatefield" UUID NOT NULL,
		"value" VARCHAR(255) NOT NULL
	);



/*****************************************
Tabellen: formtemplate

In dieser Tabelle werden die konkreten Formulare
bezogen auf den spezifischen Grenzübetritt hinterlegt.


******************************************/
	
CREATE TABLE "public"."formtemplate" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"name" UUID NOT NULL,
		"pkey_border" UUID NOT NULL
	);



/*****************************************
Tabellen: border

In dieser Tabelle werden die bestehenden 
Ländergrenzen hinterlegt. Dies geschieht in
beide Richtungen. Je aus welcher Richtung
der Fahrer kommt wird an einem Grenzüber-
gang ein anderes Formular benötigt.

z.b.
Deutschland -> Frankreich: Es wird Formular Form_DF benötigt.
Frankreich -> Deutschland: Es wird Formular Form_FD benötigt.

******************************************/
	
CREATE TABLE "public"."border" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"ridefrom" UUID NOT NULL,
		"rideto" UUID NOT NULL
	);



/*****************************************
Tabellen: healthcheck

In dieser Tabelle werden die beim Fahrer
durchgeführten Gesundheitschecks gespeichert.

[due] An welchem Tag und welcher Uhrzeit war
	der Gesundheitscheck
[pkey_guard] Wer hat ihn duchgeführt.
[status] Hier können kurze Hinweise, z.b. 
	welcher Check wurde durchgeführt hinter-
	legt werden.

******************************************/
	
CREATE TABLE "public"."healthcheck" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"pkey_driver" UUID NOT NULL,
		"pkey_guard" UUID NOT NULL,
		"due" INFORMATION_SCHEMA.TIME_STAMP NOT NULL,
		"status" VARCHAR(255)
	);


/*****************************************
Tabellen: driver

In dieser Tabelle werden die Stammdaten des
Fahrers gespeichert.

******************************************/
	
CREATE TABLE "public"."driver" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"borderguard" null DEFAULT uuid_generate_v4(),
		"firstname" VARCHAR(255),
		"lastname" VARCHAR(255),
		"street" VARCHAR(255),
		"place" VARCHAR(255),
		"country" VARCHAR(255),
		"email" VARCHAR(255),
		"mobile" VARCHAR(255),
		"birthday" DATE,
		"passportid" VARCHAR(255)
	);


	
/*****************************************
Tabellen: company

In dieser Tabelle werden die Stammdaten des
Firmen gespeichert.

******************************************/

CREATE TABLE "public"."company" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"companyname" VARCHAR(255),
		"street" VARCHAR(255),
		"place" VARCHAR(255),
		"country" VARCHAR(255),
		"email" VARCHAR(255),
		"mobile" VARCHAR(255)
	);



/*****************************************
Tabellen: driver2company

In dieser Tabelle werden die Fahrer einer
Firmen zugeordnet

******************************************/	
CREATE TABLE "public"."driver2company" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"driver_id" UUID,
		"company_id" UUID
	);



/*****************************************
Tabellen: driver2tour

In dieser Tabelle werden die Fahrer einer
Tour zugeordnet

******************************************/	
	
CREATE TABLE "public"."driver2tour" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"pkey_driver" UUID NOT NULL,
		"pkey_tour" UUID NOT NULL,
		"pkey_carregistration" UUID NOT NULL
	);



	
CREATE TABLE "public"."migration_versions" (
		"version" VARCHAR(14) NOT NULL,
		"executed_at" INFORMATION_SCHEMA.TIME_STAMP NOT NULL
	);



/*****************************************
Tabellen: tour

In dieser Tabelle werden die Tour als Anker-
punkt angelegt.

[start_date] Wann soll mit der Tour gestartet werden
[end_date] Wann soll die Tour beendet werden 
	[Forecast Angabe]

******************************************/	
		
CREATE TABLE "public"."tour" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"start_date" DATE,
		"end_date" DATE
	);



/*****************************************
Tabellen: country

In dieser Tabelle werden alle Länder als Anker-
punkt angelegt. 

******************************************/	
	
CREATE TABLE "public"."country" (
		"pkey" UUID DEFAULT uuid_generate_v4() NOT NULL,
		"countryname" VARCHAR(255) NOT NULL
	);

	
/*****************************************

Anlegen aller Constaint 

******************************************/	
	
	
CREATE UNIQUE INDEX "public"."pkey_tour" ON "public"."tour" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_formtemplate" ON "public"."formtemplate" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_tour2border" ON "public"."tour2border" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_company" ON "public"."company" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_driver2company" ON "public"."driver2company" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."migration_versions_pkey" ON "public"."migration_versions" ("version" ASC);

CREATE UNIQUE INDEX "public"."pkey_formtemplatefield" ON "public"."formtemplatefield" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_border" ON "public"."border" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_driver2tour" ON "public"."driver2tour" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_carregistration" ON "public"."carregistration" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_country" ON "public"."country" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_healthcheck" ON "public"."healthcheck" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_formfield_value" ON "public"."formfield_value" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_guard" ON "public"."guard" ("pkey" ASC);

CREATE UNIQUE INDEX "public"."pkey_driver" ON "public"."driver" ("pkey" ASC);

ALTER TABLE "public"."formtemplate" ADD CONSTRAINT "pkey_formtemplate" PRIMARY KEY ("pkey");

ALTER TABLE "public"."driver2company" ADD CONSTRAINT "pkey_driver2company" PRIMARY KEY ("pkey");

ALTER TABLE "public"."carregistration" ADD CONSTRAINT "pkey_carregistration" PRIMARY KEY ("pkey");

ALTER TABLE "public"."border" ADD CONSTRAINT "pkey_border" PRIMARY KEY ("pkey");

ALTER TABLE "public"."guard" ADD CONSTRAINT "pkey_guard" PRIMARY KEY ("pkey");

ALTER TABLE "public"."tour" ADD CONSTRAINT "pkey_tour" PRIMARY KEY ("pkey");

ALTER TABLE "public"."driver2tour" ADD CONSTRAINT "pkey_driver2tour" PRIMARY KEY ("pkey");

ALTER TABLE "public"."company" ADD CONSTRAINT "pkey_company" PRIMARY KEY ("pkey");

ALTER TABLE "public"."formfield_value" ADD CONSTRAINT "pkey_formfield_value" PRIMARY KEY ("pkey");

ALTER TABLE "public"."healthcheck" ADD CONSTRAINT "pkey_healthcheck" PRIMARY KEY ("pkey");

ALTER TABLE "public"."migration_versions" ADD CONSTRAINT "migration_versions_pkey" PRIMARY KEY ("version");

ALTER TABLE "public"."country" ADD CONSTRAINT "pkey_country" PRIMARY KEY ("pkey");

ALTER TABLE "public"."formtemplatefield" ADD CONSTRAINT "pkey_formtemplatefield" PRIMARY KEY ("pkey");

ALTER TABLE "public"."tour2border" ADD CONSTRAINT "pkey_tour2border" PRIMARY KEY ("pkey");

ALTER TABLE "public"."driver" ADD CONSTRAINT "pkey_driver" PRIMARY KEY ("pkey");

ALTER TABLE "public"."driver2tour" ADD CONSTRAINT "driver2tour_pkey_driver_fkey" FOREIGN KEY ("pkey_driver")
	REFERENCES "public"."driver" ("pkey");

ALTER TABLE "public"."formtemplatefield" ADD CONSTRAINT "formtemplatefield_name_fkey" FOREIGN KEY ("name")
	REFERENCES "public"."country" ("pkey");

ALTER TABLE "public"."formtemplatefield" ADD CONSTRAINT "formtemplatefield_pkey_formtemplate_fkey" FOREIGN KEY ("pkey_formtemplate")
	REFERENCES "public"."formtemplate" ("pkey");

ALTER TABLE "public"."driver2tour" ADD CONSTRAINT "driver2tour_pkey_carregistration_fkey" FOREIGN KEY ("pkey_carregistration")
	REFERENCES "public"."carregistration" ("pkey");

ALTER TABLE "public"."tour2border" ADD CONSTRAINT "tour2border_pkey_border_fkey" FOREIGN KEY ("pkey_border")
	REFERENCES "public"."border" ("pkey");

ALTER TABLE "public"."driver2company" ADD CONSTRAINT "driver2company_company_id_fkey" FOREIGN KEY ("company_id")
	REFERENCES "public"."company" ("pkey");

ALTER TABLE "public"."border" ADD CONSTRAINT "border_ridefrom_fkey" FOREIGN KEY ("ridefrom")
	REFERENCES "public"."country" ("pkey");

ALTER TABLE "public"."formtemplate" ADD CONSTRAINT "formtemplate_pkey_border_fkey" FOREIGN KEY ("pkey_border")
	REFERENCES "public"."border" ("pkey");

ALTER TABLE "public"."formfield_value" ADD CONSTRAINT "formfield_value_pkey_tour_fkey" FOREIGN KEY ("pkey_tour")
	REFERENCES "public"."tour" ("pkey");

ALTER TABLE "public"."formtemplate" ADD CONSTRAINT "formtemplate_name_fkey" FOREIGN KEY ("name")
	REFERENCES "public"."country" ("pkey");

ALTER TABLE "public"."driver2tour" ADD CONSTRAINT "driver2tour_pkey_tour_fkey" FOREIGN KEY ("pkey_tour")
	REFERENCES "public"."tour" ("pkey");

ALTER TABLE "public"."border" ADD CONSTRAINT "border_rideto_fkey" FOREIGN KEY ("rideto")
	REFERENCES "public"."country" ("pkey");

ALTER TABLE "public"."formfield_value" ADD CONSTRAINT "formfield_value_pkey_formtemplatefield_fkey" FOREIGN KEY ("pkey_formtemplatefield")
	REFERENCES "public"."formtemplatefield" ("pkey");

ALTER TABLE "public"."tour2border" ADD CONSTRAINT "tour2border_pkey_tour_fkey" FOREIGN KEY ("pkey_tour")
	REFERENCES "public"."tour" ("pkey");

ALTER TABLE "public"."healthcheck" ADD CONSTRAINT "healthcheck_pkey_driver_fkey" FOREIGN KEY ("pkey_driver")
	REFERENCES "public"."driver" ("pkey");

ALTER TABLE "public"."healthcheck" ADD CONSTRAINT "healthcheck_pkey_guard_fkey" FOREIGN KEY ("pkey_guard")
	REFERENCES "public"."guard" ("pkey");

ALTER TABLE "public"."carregistration" ADD CONSTRAINT "carregistration_pkey_company_fkey" FOREIGN KEY ("pkey_company")
	REFERENCES "public"."company" ("pkey");

ALTER TABLE "public"."driver2company" ADD CONSTRAINT "driver2company_driver_id_fkey" FOREIGN KEY ("driver_id")
	REFERENCES "public"."driver" ("pkey");


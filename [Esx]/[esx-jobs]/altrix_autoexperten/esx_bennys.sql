INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_Autoexperten','Autoexperten',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('Autoexperten','Autoexperten AB')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('Autoexperten',0,'recruit','Provanställd',10,'{}','{}'),
  ('Autoexperten',1,'worker','Arbetare',25,'{}','{}'),
  ('Autoexperten',2,'chef','Chef',40,'{}','{}'),
  ('Autoexperten',3,'boss','VD',0,'{}','{}')
;

INSERT INTO `items` (name, label) VALUES
  ('modEngine','Motordel'),
  ('modBrakes','Bromsdel'),
  ('modTransmission','Växellåda'),
  ('modSuspension','Fjädring'),
  ('modTurbo','Turbodel'),
  ('broken_modEngine','Trasig Motordel'),
  ('broken_modBrakes','Trasig Bromsdel'),
  ('broken_modTransmission','Trasig Växellåda'),
  ('broken_modSuspension','Trasig Fjädring'),
  ('broken_modTurbo','Trasig Turbo'),
  ('part','Bodypartdel'),
  ('broken_part','Trasig Bodypartdel')
;
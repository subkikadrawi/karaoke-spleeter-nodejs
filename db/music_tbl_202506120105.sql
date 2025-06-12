CREATE TABLE forge.music_tbl (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  pathUrl VARCHAR(255),
  pathUrlImage VARCHAR(255),
  pathUrlVocal VARCHAR(255),
  pathUrlInstrumental VARCHAR(255),
  sourceKaraoke VARCHAR(50),
  created_at DATETIME,
  update_at DATETIME,
  created_by INT,
  update_by INT,
  status INT
);

INSERT INTO forge.music_tbl (title,pathUrl,pathUrlImage,pathUrlVocal,pathUrlInstrumental,sourceKaraoke,created_at,update_at,created_by,update_by,status) VALUES
	 ('indo - Sule Ft Shima - Terpisah Jarak Dan Waktu','/indo/Sule Ft Shima - Terpisah Jarak Dan Waktu.mp4',NULL,'/indo/separated/Sule Ft Shima - Terpisah Jarak Dan Waktu/vocals.mp3','/indo/separated/Sule Ft Shima - Terpisah Jarak Dan Waktu/no_vocals.mp3','music','2025-05-31 01:55:48',NULL,1,NULL,NULL),
	 ('indo - Last Child - Diary despresiku','/indo/Last Child - Diary despresiku.mp4',NULL,'/indo/separated/Last Child - Diary despresiku/vocals.mp3','/indo/separated/Last Child - Diary despresiku/no_vocals.mp3','music','2025-06-06 20:11:25',NULL,1,NULL,NULL),
	 ('indo - BEE GEES - YOU WIN AGAIN','/indo/BEE GEES - YOU WIN AGAIN.mp4',NULL,'/indo/separated/BEE GEES - YOU WIN AGAIN/vocals.mp3','/indo/separated/BEE GEES - YOU WIN AGAIN/no_vocals.mp3','music','2025-06-06 20:11:25',NULL,1,NULL,NULL),
	 ('indo - Andika Mahesa - Sai Anju Ma Au','/indo/Andika Mahesa - Sai Anju Ma Au.mp4',NULL,'/indo/separated/Andika Mahesa - Sai Anju Ma Au/vocals.mp3','/indo/separated/Andika Mahesa - Sai Anju Ma Au/no_vocals.mp3','music','2025-06-06 20:11:25',NULL,1,NULL,NULL);

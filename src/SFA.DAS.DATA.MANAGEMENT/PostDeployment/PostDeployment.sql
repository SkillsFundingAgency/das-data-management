﻿/* Execute Stored Procedure */

EXEC [dbo].[Build_AS_DataMart]
DROP TABLE IF EXISTS [ASData_PL].[RP_AppealUpload]

/* Atos Test Data -- Only for AT & Test Environments */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = N'AI_TestData'
		      AND TABLE_SCHEMA=N'Stg'
	      )
DROP TABLE Stg.AI_TestData

CREATE TABLE Stg.AI_TestData(
  id INT NOT NULL,
  target INT NOT NULL,
  dep_var1 VARCHAR(10) NOT NULL,
  dep_var2 INT NOT NULL,
  dep_var3 INT NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO Stg.AI_TestData
    (id, target, dep_var1, dep_var2, dep_var3) 
VALUES 
(1,0,'C6163',100,1),
(2,1,'C2350',88,2),
(3,0,'C7901',36,2),
(4,1,'C1921',97,2),
(5,1,'C880',100,11),
(6,1,'C6768',57,1),
(7,0,'C1544',57,2),
(8,1,'C7018',58,2),
(9,1,'C8665',93,2),
(10,0,'C3882',25,1),
(11,1,'C27',32,1),
(12,1,'C5555',54,23),
(13,0,'C4823',107,1),
(14,1,'C5858',103,3),
(15,0,'C6209',30,2),
(16,1,'C3722',63,5),
(17,1,'C6921',40,1),
(18,1,'C8609',100,1),
(19,1,'C5522',52,5),
(20,0,'C8872',67,1),
(21,1,'C5571',43,1),
(22,0,'C719',33,2),
(23,0,'C8536',70,2),
(24,0,'C7709',53,3),
(25,1,'C3015',56,3),
(26,0,'C6369',88,2),
(27,1,'C9055',32,2),
(28,0,'C6707',32,1),
(29,1,'C1608',29,2),
(30,0,'C6700',78,1),
(31,0,'C7693',101,2),
(32,1,'C8540',25,1),
(33,1,'C1234',56,4),
(34,1,'C5958',86,9),
(35,1,'C8158',92,1),
(36,1,'C4306',77,2),
(37,1,'C6733',84,1),
(38,0,'C6230',32,1),
(39,0,'C7081',95,5),
(40,1,'C8771',43,2),
(41,0,'C8747',91,1),
(42,1,'C4932',102,2),
(43,0,'C4552',31,1),
(44,1,'C2800',106,2),
(45,1,'C7573',79,48),
(46,0,'C5812',72,1),
(47,1,'C470',62,156),
(48,1,'C2903',49,2),
(49,0,'C3855',50,1),
(50,1,'C4948',103,1),
(51,0,'C3097',34,1),
(52,0,'C2792',92,5),
(53,0,'C7387',25,2),
(54,1,'C9257',74,2),
(55,0,'C7900',62,3),
(56,0,'C7901',31,3),
(57,1,'C2483',58,2),
(58,0,'C5292',92,1),
(59,0,'C38',61,3),
(60,1,'C6551',93,7),
(61,0,'C576',65,5),
(62,1,'C5039',40,2),
(63,1,'C1389',67,4),
(64,1,'C9827',27,16),
(65,1,'C7980',25,1),
(66,1,'C1443',67,2),
(67,1,'C2406',49,2),
(68,0,'C3907',34,6),
(69,1,'C9652',64,7),
(70,0,'C4268',75,6),
(71,0,'C9294',92,1),
(72,0,'C6507',87,6),
(73,0,'C1900',51,6),
(74,1,'C5795',25,4),
(75,0,'C8751',70,1),
(76,0,'C4330',100,2),
(77,1,'C7902',47,1),
(78,1,'C4062',28,2),
(79,1,'C2910',82,1),
(80,1,'C6415',106,2),
(81,1,'C2250',64,1),
(82,0,'C5452',77,1),
(83,0,'C6759',59,2),
(84,0,'C5342',89,3),
(85,1,'C7948',84,1),
(86,1,'C3894',21,4),
(87,0,'C2033',20,2),
(88,1,'C713',54,1),
(89,0,'C8920',92,2),
(90,1,'C9845',61,2),
(91,0,'C5767',96,3),
(92,1,'C3130',55,2),
(93,0,'C5849',94,1),
(94,1,'C8726',92,2),
(95,0,'C8321',98,3),
(96,1,'C6559',47,3),
(97,0,'C7471',68,8),
(98,1,'C4975',89,2),
(99,0,'C8482',61,1),
(100,1,'C8320',38,3),
(101,1,'C3401',84,2),
(102,1,'C8002',91,28),
(103,0,'C2761',18,1),
(104,1,'C959',95,3),
(105,0,'C9811',61,11),
(106,0,'C4917',47,2),
(107,1,'C1352',92,3),
(108,1,'C6257',101,1),
(109,1,'C3334',88,1),
(110,0,'C9773',102,1),
(111,1,'C3430',68,10),
(112,1,'C9758',53,2),
(113,1,'C2374',20,3),
(114,1,'C744',21,1),
(115,1,'C9777',79,1),
(116,0,'C9181',32,1),
(117,0,'C1812',55,2),
(118,1,'C3015',101,5),
(119,0,'C4166',93,1),
(120,0,'C47',50,2),
(121,0,'C3204',32,1),
(122,1,'C6346',50,2),
(123,0,'C2896',50,2),
(124,0,'C1521',38,2),
(125,1,'C5647',61,1),
(126,1,'C3218',77,2),
(127,1,'C1670',66,1),
(128,0,'C8630',36,2),
(129,1,'C7737',38,5),
(130,0,'C579',65,2),
(131,1,'C1391',42,3),
(132,1,'C3790',71,1),
(133,0,'C2472',105,4),
(134,1,'C7839',97,16184),
(135,0,'C4836',105,1),
(136,0,'C7570',35,2),
(137,1,'C1177',96,2),
(138,1,'C6589',32,1),
(139,0,'C6384',93,1),
(140,0,'C2572',29,1),
(141,1,'C1644',35,1),
(142,0,'C241',42,9),
(143,0,'C8941',34,2),
(144,1,'C2053',38,2),
(145,1,'C9518',60,1),
(146,1,'C8711',83,2),
(147,1,'C197',60,4),
(148,0,'C2216',74,7),
(149,0,'C3175',83,1),
(150,1,'C5841',38,5),
(151,0,'C5445',25,2),
(152,0,'C1445',66,2),
(153,0,'C1093',76,2),
(154,0,'C3571',96,1),
(155,1,'C3451',51,2),
(156,1,'C4301',55,4),
(157,1,'C9273',102,1),
(158,0,'C337',50,1),
(159,0,'C8369',75,2),
(160,1,'C1330',106,1),
(161,1,'C1114',94,2),
(162,0,'C3823',26,8),
(163,0,'C4327',77,4),
(164,0,'C7004',25,1),
(165,0,'C4961',40,4),
(166,1,'C581',97,3),
(167,1,'C4240',20,1),
(168,1,'C4469',47,6),
(169,1,'C9626',34,4),
(170,0,'C5046',49,3),
(171,0,'C7429',101,3),
(172,0,'C857',40,1),
(173,0,'C2106',19,2),
(174,1,'C4163',34,7),
(175,1,'C4982',46,2),
(176,0,'C9073',91,2),
(177,0,'C9565',64,4),
(178,0,'C1950',86,104),
(179,1,'C6527',86,1),
(180,1,'C7994',37,5),
(181,1,'C2654',37,5),
(182,0,'C5171',74,2),
(183,1,'C3884',61,2),
(184,1,'C6682',79,1),
(185,1,'C5337',60,1),
(186,0,'C7361',92,10),
(187,0,'C9201',32,3),
(188,0,'C8182',102,2),
(189,1,'C8302',99,2),
(190,0,'C1964',32,2),
(191,0,'C434',59,2),
(192,0,'C5921',97,2),
(193,0,'C5766',61,12),
(194,1,'C3849',28,1),
(195,0,'C6406',36,3),
(196,1,'C3000',36,1),
(197,0,'C5807',56,1),
(198,1,'C4772',51,14),
(199,1,'C7089',59,1),
(200,1,'C6831',51,12)
;





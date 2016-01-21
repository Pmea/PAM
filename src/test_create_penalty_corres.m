% script pour tester f_create_penalty

close all;
clear all;


ext_gap= -1;
open_gap= -2;

[m_seuil, m_penalty, m_corres]= f_creer_penalty_et_corres(ext_gap, open_gap);

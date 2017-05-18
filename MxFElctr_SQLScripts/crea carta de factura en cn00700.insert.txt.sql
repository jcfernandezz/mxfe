select *
from cn00700

insert into cn00700(
Letter_Type,
LTRRPTNM,
LTRDESC,
Hide_in_lookup,
CN_Print_Using_Report,
Action_Promised,
CN_Email_Subject,
CN_Word_Letter,
CN_Word_Document_File,
CN_LetterPerAddress,
InvoicesToAttach,
CN_CopySalesperson,
CN_Letter_Text)
select Letter_Type,
'FACTURA_ELECTRONICA',
LTRDESC,
Hide_in_lookup,
CN_Print_Using_Report,
Action_Promised,
CN_Email_Subject,
CN_Word_Letter,
CN_Word_Document_File,
CN_LetterPerAddress,
InvoicesToAttach,
CN_CopySalesperson,
CN_Letter_Text
from cn00700
where LTRRPTNM = 'CN_Letter04                    '

sp_columns cn00700


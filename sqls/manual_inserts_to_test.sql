--      Este arquivo foi criado para facilitar ao testador inserir
-- grande quantia de dados no postgres.
--      A quantia de linhas a ser inseridas, vai depender do valor
-- definido na variável "total"

do
$do$
declare
     i int;
	 total int = 200;
begin
   FOR i IN 1..total LOOP
      INSERT INTO public.usuario
         (nome, kafka)                       -- declare target columns!
     VALUES('teste ' || i, now());
   END LOOP;
END;
$do$;

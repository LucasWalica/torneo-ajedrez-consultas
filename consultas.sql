1. Nombre, dirección y teléfono de todos los participantes de España.

    select p.nombre, p.dirección, p.teléfono from participantes p
    join paises on p.numPaís = paises.numero
    where paises.nombre = "España"

2. Nombre y dirección de todos los hoteles en los que se han alojado jugadores de España.

    select h.nombre, h.dirección from hoteles h 
    join alojar on h.nombre = alojar.nombreHotel 
    join participantes on participantes.numAsociado = alojar.numAsociado
    join paises on participantes.numPais = paises.numero 
    where paises.nombre = "España"

3. Nombre los participantes en cada partida junto con su nacionalidad y el número de partida.

    select blancas.nombre, paises_blancas.nombre, negras.nombre, paises_negras.nombre, arbitro.nombre, paises_arbitro.nombre, partidas.numero from partidas
    join jugadores as blancas on partidas.blancas = blancas.numAsociado
    join jugadores as negras on partidas.negras = negras.numAsociado
    join arbitros  as arbitro on partidas.arbitro = arbitros.numAsociado
    join participantes as participantes_blancas on  blancas.numAsociado = participantes_blancas.numAsociado
    join participantes as participantes_negras on  negras.numAsociado = participantes_negras.numAsociado 
    join participantes as participantes_arbitro on  arbitro.arbitro = participantes_arbitro.numAsociado 
    join paises as paises_blancas on participantes_blancas.numPais = paises_blancas.numero
    join paises as paises_negras on participantes_negras.numPais = paises_negras.numero
    join paises as paises_arbitro = participantes_arbitro.numPais = paises_arbitro.numero;


4. Nombre de jugadores y árbitro, número de partida y nombre de hotel y sala, de las partidas
celebradas el 10 de mayo de 2009.

    select participante_blancas.nombre, participante_negras.nombre, participante_arbitro.nombre, partidas.numero, salas.nombreHotel, salas.nombreSala, partidas.fecha from partidas
    join jugadores as jugador_blancas on partidas.blancas = jugadores.numAsociado
    join jugadores as jugador_negras on partidas.negras = jugadores.numAsociado
    join arbitros as arbitro on partidas.árbitro = arbitros.numAsociado
    join participantes as participante_blancas on jugador_blancas.numAsociado = participantes.numAsociado
    join participantes as participante_negras on jugador_negras.numAsociado = participantes.numAsociado
    join participantes as participante_arbitro on arbitro.numAsociado = participantes.numAsociado
    join salas on partidas.nombreHotel = salas.nombreHotel
    where partidas.fecha = 10-05-2009


5. Nombre, dirección y teléfono del hotel u hoteles en los que se haya celebrado el mayor número de
partidas.



6. Nombre de la sala o salas de mayor capacidad y nombre de su hotel.

    select salas.nombre, sala.nombreHote from salas 
    where salas.capacidad = (select max(salas.capacidad) from salas);

7. Nombre, dirección y teléfono del hotel u hoteles que poseen la sala de mayor capacidad.

    select hoteles.nombre, hoteles.dirección, hoteles.dirección from hoteles
    join salas on hoteles.nombre = salas.nombreHotel
    where salas.capacidad = (select max(salas.capacidad) from salas);

8. De aquellas partidas en las que el número de entradas vendidas ha sido inferior al 50% de la
capacidad de la sala donde se han celebrado, mostrar el nombre del hotel y de la sala , el nombre
de los jugadores y la fecha con el formato del ejemplo siguiente: Miércoles, 3 de junio de 2009.

    select salas.nombreHotel, salas.nombreSala, CONCAT(participante_blancas.nombre, ' vs ',participante_negras.nombre) as jugadores, DATE_FORMAT(partidas.fecha '%W, %e de %M de %Y') as fecha from partidas 
    join salas on partidas.nombreSala = salas.nombreSala
    join jugadores as jugador_blancas on partidas.blancas = jugadores.numAsociado
    join jugadores as jugador_negras on partidas.negras = jugadores.numAsociado
    join participantes as participante_blancas on jugador_blancas.numAsociado = participantes.numAsociado
    join participantes as participante_negras on jugador_negras.numAsociado = participantes.numAsociado
    where partidas.entradas < salas.capacidad*0.5;


9. De aquellas partidas en las que el número de movimientos realizados está entre los 5 mayores,
mostrar el número de partida, la fecha de celebración, el lugar de celebración, el nombre de los
participantes y el número de movimientos.

select 
    partidas.numero as numPartida , 
    DATE_FORMAT(partidas.fecha '%W,  %e de %M de %Y') as fecha, 
    CONCAT( participante_blancas.nombre, ' vs ' ,participante_negras.nombre) as jugadores, 
    partidas.nombreHotel as Hotel,
    partidas.nombreSala as Sala 
from partidas
    join jugadores as jugador_blancas on partidas.blancas = jugadores.numAsociado
    join jugadores as jugador_negras on partidas.negras = jugadores.numAsociado
    join participantes as participante_blancas on jugador_blancas = participantes.numAsociado
    join participantes as participante_negras on jugador_negras = participantes.numAsociado
    join movimientos on partidas.numero = movimientos.numPartida
ORDER BY 
    (select MAX(movimientos.numMovimiento) from movimientos)
DESC LIMIT 5;

10. Nombre de todos los jugadores que no han participado en partidas celebradas un lunes.

    select DISTINCT(participantes.nombre) from partidas
    join jugadores as negras on partidas.negras = jugadores.numAsociado 
    join jugadores as blancas on partidas.blancas  = jugadores.numAsociado
    join participantes on negras.numAsociado = participantes.numAsociado
    join participantes on blancas.numAsociado = participantes.numAsociado
    WHERE DAYOFWEEK(partidas.fecha) != 2;
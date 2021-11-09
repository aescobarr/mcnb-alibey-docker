-- Organization
INSERT INTO public.georef_addenda_organization(id,name) values (1,'Default org');

-- Site type
INSERT INTO public.tipustoponim(id,nom) values ('type_0','unknown');

-- Version qualifier
INSERT INTO public.qualificadorversio(id, qualificador) values ('qualifier_0','Initial version');

-- Content type
INSERT INTO public.tipusrecursgeoref(id, nom) values ('resource_type_0','Map');

-- Toponim 0
INSERT into public.toponim(
    id,
    nom,
    aquatic,
    idtipustoponim,
    denormalized_toponimtree,    
    idorganization_id
    )
    values 
    (
        '0',
        'World',
        'S',
        'type_0',
        '',
        1
    );

-- First version of toponim 0
INSERT into public.toponimversio(
    id,  
    nom,
    datacaptura,
    idtoponim,
    numero_versio,
    idqualificador,    
    last_version  
)
values(
    'world_version_0',
    'World',
    CURRENT_DATE,
    '0',
    1,
    'qualifier_0',    
    true
);
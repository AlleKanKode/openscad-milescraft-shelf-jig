// Distance from edge in mm
edge_distance = 7;

// Modul til at skabe en rektangel med afrundede hjørner
module rounded_rectangle(bredde, laengde, hoejde, radius, $fn = 60) {
    if (bredde < 2*radius || laengde < 2*radius) {
        echo("FEJL: Bredde eller længde er for lille i forhold til radius. Kan ikke skabe formen.");
    } else {
        // Vi bruger union til at kombinere flere primitive former til et solidt objekt
        union() {
            // Hovedfirkanten
            cube([bredde, laengde - 2*radius, hoejde], center = true);
            // Sidefirkanten
            cube([bredde - 2*radius, laengde, hoejde], center = true);

            // Fire cylindre til de afrundede hjørner
            translate([bredde/2 - radius, laengde/2 - radius, 0])
                cylinder(h = hoejde, r = radius, $fn = $fn, center = true);
            translate([-bredde/2 + radius, laengde/2 - radius, 0])
                cylinder(h = hoejde, r = radius, $fn = $fn, center = true);
            translate([bredde/2 - radius, -laengde/2 + radius, 0])
                cylinder(h = hoejde, r = radius, $fn = $fn, center = true);
            translate([-bredde/2 + radius, -laengde/2 + radius, 0])
                cylinder(h = hoejde, r = radius, $fn = $fn, center = true);
        }
    }
}

// Modul til at tilføje huller i et objekt
module add_holes(hul_diameter, hul_afstand_x, hul_afstand_y, hoejde, $fn = 60) {
    difference() {
        children(0); 
        
        translate([
            -hul_afstand_x,
            hul_afstand_y,
            0
        ]) {
            cylinder(h = hoejde + 0.1, r = hul_diameter / 2, $fn = $fn, center = true);
        }
        
        translate([
            hul_afstand_x,
            hul_afstand_y,
            0
        ]) {
            cylinder(h = hoejde + 0.1, r = hul_diameter / 2, $fn = $fn, center = true);
        }
    }
}


// Samleobjekt
union() {
    // mdim_ variables are used for fixed values needed for the Milescraft Shelf Jig
    mdim_length = 185;
    
    // thickness of the parts
    mdim_thick_jig = 6;
    mdim_thick_top = 5;
    mdim_thick_edge = 15;   
    
    // holes dimensions
    mdim_holes_distance = 161;   
    mdim_holes_edge_distance = 10;   
    
    hoejde_val = 5;
    gulv = hoejde_val /2;
    samlede_bredde = 80;
    samlede_lengde = 185;

    
    // Første rektangel uden huller
    // Den nederste klods
    translate([0, 0, gulv]) {
        rounded_rectangle(bredde = samlede_lengde, laengde = samlede_bredde, hoejde = hoejde_val, radius = 5);
    }
    
    
    // Anden rektangel uden huller, placeret ved siden af
    translate([0, 50, gulv + hoejde_val]) {
        rounded_rectangle(bredde = samlede_lengde, laengde = 30, hoejde = hoejde_val, radius = 3);
    }   
    
    
    // Tredje rektangel med huller
    // Her beregnes den korrekte afstand fra midten
    translate([0, 60, hoejde_val / 2]) {
        bredde_3 = 130;
        laengde_3 = 20;
        afstand_fra_kanten = 5; // Ønsket afstand fra kanten i y-retningen
        
        // Beregner afstanden fra midten, som add_holes-modulet forventer
        hul_afstand_y_beregnet = (laengde_3 / 2) - afstand_fra_kanten;

        add_holes(
            hul_diameter = 5,
            hul_afstand_x = 60,
            hul_afstand_y = hul_afstand_y_beregnet,
            hoejde = hoejde_val
        ) {
            rounded_rectangle(
                bredde = bredde_3,
                laengde = laengde_3,
                hoejde = hoejde_val,
                radius = 3
            );
        }
    }
}

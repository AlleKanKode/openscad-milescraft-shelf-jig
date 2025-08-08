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
    mdim_top_width  = 50;
    mdim_base_width = 30;
    
    mdim_corner_radius = 5;
    
    // thickness of the parts
    mdim_thick_jig = 6;
    mdim_thick_top = 5;
    mdim_thick_edge = 15;   
    
    // holes dimensions
    mdim_holes_distance = 161;   
    mdim_holes_edge_distance = 10; 
    mdim_holes_width = 5;
    
    /*
    hoejde_val = 5;
    gulv = hoejde_val /2;
    samlede_bredde = 80;
    samlede_lengde = 185;
    */

    bottom_y = (mdim_base_width + edge_distance) / 2;
    bottom_z = (mdim_thick_edge) / 2;
    
    middle_y = (mdim_base_width) / 2;
    middle_z = (mdim_thick_jig) / 2 + mdim_thick_edge;
    
    top_y    = (mdim_top_width) / 2;
    top_z    = (mdim_thick_top) / 2 + mdim_thick_edge + mdim_thick_jig;

    
    // The lower fench part
    // Den nederste klods
    translate([0, bottom_y, bottom_z]) {
        rounded_rectangle(bredde = mdim_length, laengde = mdim_base_width + edge_distance, hoejde = mdim_thick_edge, radius = mdim_corner_radius);
    }
    
    // The middle fench part    
    color("green") {
    translate([0, middle_y, middle_z]) {
        rounded_rectangle(bredde = mdim_length, laengde = mdim_base_width, hoejde = mdim_thick_jig, radius = mdim_corner_radius);
    }   
    }
    
    
    // Tredje rektangel med huller
    // Her beregnes den korrekte afstand fra midten
    color("red") {
    translate([0, top_y, top_z]) {
        bredde_3 = mdim_length;
        laengde_3 = mdim_top_width;
        afstand_fra_kanten = mdim_holes_edge_distance; // Ønsket afstand fra kanten i y-retningen
        
        // Beregner afstanden fra midten, som add_holes-modulet forventer
        hul_afstand_y_beregnet = (laengde_3 / 2) - afstand_fra_kanten;

        add_holes(
            hul_diameter = mdim_holes_width,
            hul_afstand_x = mdim_holes_distance / 2,
            hul_afstand_y = hul_afstand_y_beregnet,
            hoejde = mdim_thick_top
        ) {
            rounded_rectangle(
                bredde = mdim_length,
                laengde = mdim_top_width,
                hoejde = mdim_thick_top,
                radius = mdim_corner_radius
            );
        }
    }
    }
}

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
// Samleobjekt
union() {
    hoejde_val = 5;

    // Første rektangel uden huller
    translate([0, 0, hoejde_val / 2]) {
        rounded_rectangle(bredde = 180, laengde = 40, hoejde = hoejde_val, radius = 5);
    }

    // Anden rektangel uden huller, placeret ved siden af
    translate([0, -60, hoejde_val / 2]) {
        rounded_rectangle(bredde = 150, laengde = 30, hoejde = hoejde_val, radius = 3);
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
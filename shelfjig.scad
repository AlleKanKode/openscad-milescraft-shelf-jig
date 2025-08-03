// Modul til at skabe en rektangel med afrundede hjørner
module rounded_rectangle(bredde, laengde, hoejde, radius, $fn = 60) {
    if (bredde < 2*radius || laengde < 2*radius) {
        echo("FEJL: Bredde eller længde er for lille i forhold til radius. Kan ikke skabe formen.");
    } else {
        union() {
            // Firkanten i midten af rektanglen
            cube([bredde - 2*radius, laengde, hoejde], center = true);

            // De to rektangler på siderne
            cube([bredde, laengde - 2*radius, hoejde], center = true);

            // De fire afrundede hjørner
            // Vi placerer fire cylindre i hvert hjørne
            translate([bredde/2 - radius, laengde/2 - radius, 0]) cylinder(h = hoejde, r = radius, $fn = $fn, center = true);
            translate([-bredde/2 + radius, laengde/2 - radius, 0]) cylinder(h = hoejde, r = radius, $fn = $fn, center = true);
            translate([bredde/2 - radius, -laengde/2 + radius, 0]) cylinder(h = hoejde, r = radius, $fn = $fn, center = true);
            translate([-bredde/2 + radius, -laengde/2 + radius, 0]) cylinder(h = hoejde, r = radius, $fn = $fn, center = true);
        }
    }
}

// Modul til at tilføje huller i et objekt
module add_holes(hul_diameter, hul_afstand_x, hul_afstand_y, hoejde, $fn = 60) {
    difference() {
        children(0); 
        
        // Første hul i øverste venstre hjørne
        translate([
            -hul_afstand_x,
            hul_afstand_y,
            0
        ]) {
            cylinder(h = hoejde + 0.1, r = hul_diameter / 2, $fn = $fn, center = true); // <-- Tilføjet center = true
        }
        
        // Andet hul i øverste højre hjørne
        translate([
            hul_afstand_x,
            hul_afstand_y,
            0
        ]) {
            cylinder(h = hoejde + 0.1, r = hul_diameter / 2, $fn = $fn, center = true); // <-- Tilføjet center = true
        }
    }
}

// Vi samler alle dele med 'union'
union() {
/*
    // Første rektangel uden huller
    rounded_rectangle(bredde = 180, laengde = 40, hoejde = 5, radius = 5);

    // Anden rektangel uden huller, placeret ved siden af
    translate([0, -60, 0]) {
        rounded_rectangle(bredde = 150, laengde = 30, hoejde = 5, radius = 3);
    }
*/    
    // Tredje rektangel med huller
    // Vi bruger 'add_holes' modulet til at modificere rektanglen
    translate([0, 60, 0]) {
        add_holes(hul_diameter = 5, hul_afstand_x = 161/2, hul_afstand_y = 10, hoejde = 5) {
            rounded_rectangle(bredde = 185, laengde = 30, hoejde = 5, radius = 3);
        }
    }
}

cube([10, 10, 10], center = false               );
// Her er din modul-definition (fra Trin 1)

/*
module rounded_rectangle(bredde, laengde, hoejde, radius, $fn = 60) {
    if (bredde < 2*radius || laengde < 2*radius) {
        echo("FEJL: Bredde eller længde er for lille i forhold til radius. Kan ikke skabe formen.");
    } else {
        minkowski() {
            cube([bredde - 2*radius, laengde - 2*radius, hoejde], center = true);
            cylinder(h = hoejde, r = radius, $fn = $fn);
        }
    }
}
*/

/*
// rounded_rectangle_med_huller.scad
// rounded_rectangle_med_huller.scad - RETTET VERSION

module rounded_rectangle_med_huller(bredde, laengde, hoejde, radius, hul_diameter, hul_afstand, $fn = 60) {
    
    hul_radius = hul_diameter / 2;

    difference() {
        // Første objekt er basen: rektanglen med afrundede hjørner
        // OpenSCAD behandler dette som det objekt, der skal trækkes fra
        minkowski() {
            cube([bredde - 2*radius, laengde - 2*radius, hoejde], center = true);
            cylinder(h = hoejde, r = radius, $fn = $fn);
        }
        
        // De følgende objekter bliver trukket fra basen
        
        // Venstre hul
        translate([-hul_afstand / 2, 0, 0]) {
            cylinder(h = hoejde + 0.1, r = hul_radius, $fn = $fn, center = true);
        }
        
        // Højre hul
        translate([hul_afstand / 2, 0, 0]) {
            cylinder(h = hoejde + 0.1, r = hul_radius, $fn = $fn, center = true);
        }
    }
}
*/

// rounded_rectangle_med_huller_hjørne.scad

module rounded_rectangle_med_huller(bredde, laengde, hoejde, radius, hul_diameter, hul_afstand_x, hul_afstand_y, $fn = 60) {
    
    hul_radius = hul_diameter / 2;

    difference() {
        // Rektanglen med de afrundede hjørner
        minkowski() {
            cube([bredde - 2*radius, laengde - 2*radius, hoejde], center = true);
            cylinder(h = hoejde, r = radius, $fn = $fn);
        }
        
        // Første hul i øverste venstre hjørne
        translate([
            -bredde / 2 + hul_afstand_x,
            laengde / 2 - hul_afstand_y,
            0
        ]) {
            cylinder(h = hoejde + 0.1, r = hul_radius, $fn = $fn, center = true);
        }
        
        // Andet hul i øverste højre hjørne
        translate([
            bredde / 2 - hul_afstand_x,
            laengde / 2 - hul_afstand_y,
            0
        ]) {
            cylinder(h = hoejde + 0.1, r = hul_radius, $fn = $fn, center = true);
        }
    }
}

/*
// Her kalder du modulet for at tegne din rektangel
rounded_rectangle(bredde = 50, laengde = 30, hoejde = 5, radius = 5);

// Du kan også kalde modulet med andre værdier
translate([0, 40, 0]) {
    rounded_rectangle(bredde = 20, laengde = 20, hoejde = 10, radius = 3);
}
*/

/*
// Brug dit nye modul
rounded_rectangle_med_huller(
    bredde = 180, 
    laengde = 40, 
    hoejde = 5, 
    radius = 5, 
    hul_diameter = 5, 
    hul_afstand = 161
);
*/

rounded_rectangle_med_huller(
    bredde = 180, 
    laengde = 40, 
    hoejde = 5, 
    radius = 5, 
    hul_diameter = 5, 
    hul_afstand_x = 10,  // Afstand fra venstre og højre kant
    hul_afstand_y = 10   // Afstand fra topkanten
);
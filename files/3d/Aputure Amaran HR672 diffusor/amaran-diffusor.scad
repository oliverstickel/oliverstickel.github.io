/* =====================================================================
   AMARAN HR672 / AL-528 SOFTBOX & DIFFUSOR
   Druck-Orientierung: Auf der Vorderseite liegend (Z=0 ist der Diffusor)
   ===================================================================== */

$fn = 100; // Hohe Auflösung für saubere Rundungen

// --- 1. GERÄTE-MASSE (Amaran Gehäuse) ---
panel_width = 238.0;      // Breite des Panels
panel_height = 190.0;     // Höhe des Panels
panel_corner_r = 6.0;     // Eckenradius des Gehäuses
tolerance = 0.6;          // Spaltmaß für den "Friction Fit" (pro Seite)

// --- 2. BEFESTIGUNG (1/4" GEWINDE) ---
hole_diameter = 6.8;      // Durchmesser der Löcher für 1/4" Schraube (inkl. Spielraum)
hole_dist_from_front = 12.0; // Abstand Mitte Gewinde zur VORDERKANTE des Panels (BITTE AM GERÄT MESSEN!)
collar_depth = 25.0;      // Wie weit ragt der Kragen über das Gerät (muss größer als hole_dist_from_front sein)

// --- 3. SOFTBOX-FORM (Trichter) ---
funnel_depth = 50.0;      // Wie weit steht die Softbox nach vorne ab
flare_x = 6.0;           // Verbreiterung nach links/rechts (pro Seite)
flare_y = 25.0;           // Verbreiterung nach oben/unten (pro Seite)
wall_thickness = 2.0;     // Wandstärke der Konstruktion
diffuser_thickness = 0.5; // Dicke der vordersten Schicht (z.B. 1 Layer bei 0.2mm)


// =====================================================================
// BERECHNUNGEN (Ab hier nichts mehr ändern)
// =====================================================================

// Innenmaße des Kragens
inner_w = panel_width + (tolerance * 2);
inner_h = panel_height + (tolerance * 2);

// Außenmaße des Kragens
outer_w = inner_w + (wall_thickness * 2);
outer_h = inner_h + (wall_thickness * 2);
outer_r = panel_corner_r + wall_thickness;

// Außenmaße der Front (Diffusor)
front_outer_w = outer_w + (flare_x * 2);
front_outer_h = outer_h + (flare_y * 2);
front_outer_r = outer_r + (flare_x / 2); // Ästhetische Skalierung der Rundung

// Innenmaße der Front (wo der Trichter beginnt)
front_inner_w = front_outer_w - (wall_thickness * 2);
front_inner_h = front_outer_h - (wall_thickness * 2);
front_inner_r = max(0.1, front_outer_r - wall_thickness);


// =====================================================================
// MODULE
// =====================================================================

// Hilfsmodul für abgerundete Rechtecke
module rounded_rect(w, h, r) {
    offset(r=r) square([w - 2*r, h - 2*r], center=true);
}

// Hauptkonstruktion
module softbox() {
    
    // 1. DIE DIFFUSOR-SCHICHT (Ganz unten auf dem Druckbett)
    color("white")
    linear_extrude(diffuser_thickness)
        rounded_rect(front_outer_w, front_outer_h, front_outer_r);
    
    // 2. DER TRICHTER (Hohler Übergang)
    color("darkgrey")
    translate([0, 0, diffuser_thickness])
    difference() {
        // Äußere Hülle des Trichters
        hull() {
            linear_extrude(0.01) 
                rounded_rect(front_outer_w, front_outer_h, front_outer_r);
            translate([0, 0, funnel_depth - diffuser_thickness]) 
                linear_extrude(0.01) 
                rounded_rect(outer_w, outer_h, outer_r);
        }
        // Innere Aushöhlung des Trichters
        hull() {
            linear_extrude(0.01) 
                rounded_rect(front_inner_w, front_inner_h, front_inner_r);
            // Minimal überlappen lassen (0.02) um Render-Fehler zu vermeiden
            translate([0, 0, funnel_depth - diffuser_thickness + 0.02]) 
                linear_extrude(0.01) 
                rounded_rect(inner_w, inner_h, panel_corner_r);
        }
    }
    
    // 3. DER KRAGEN (Rutscht über das Gerät)
    color("grey")
    translate([0, 0, funnel_depth])
    difference() {
        // Außenwand Kragen
        linear_extrude(collar_depth) 
            rounded_rect(outer_w, outer_h, outer_r);
        
        // Innenwand Kragen (Aushöhlung fürs Gerät)
        translate([0, 0, -0.1]) 
            linear_extrude(collar_depth + 0.2) 
            rounded_rect(inner_w, inner_h, panel_corner_r);
        
        // Löcher für die 1/4" Schrauben (links und rechts)
        // Y-Achse drehen, um quer durchzustechen
        translate([0, 0, hole_dist_from_front])
        rotate([0, 90, 0])
            cylinder(h=outer_w + 10, r=hole_diameter/2, center=true);
    }
}

// =====================================================================
// RENDER
// =====================================================================
softbox();
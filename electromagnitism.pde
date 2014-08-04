

// <options>
short CANVAS_SIZE = 1000;
short HEXAGON_RADIUS = 500;
byte POSITIVE_CHARGES = 5;
byte NEGATIVE_CHARGES = 5;
float Q = 0.001;
// </options>


// <setup_environment>
short padding = (short)((CANVAS_SIZE - HEXAGON_RADIUS * 2) / 2);
size(CANVAS_SIZE, CANVAS_SIZE);
int center = CANVAS_SIZE / 2;
float ELECTRIC_PERMITTIVITY = 8.8541878176 * pow(10, -12);
background(0, 0, 0);
stroke(0, 0, 0);
strokeWeight(4);
// </setup_environment>


// <hexagon_points>
PVector p[] = new PVector[6];
p[0] = new PVector(center - HEXAGON_RADIUS, center);
p[1] = new PVector(center - HEXAGON_RADIUS * cos(PI/3), center - HEXAGON_RADIUS * sin(PI/3));
p[2] = new PVector(center + HEXAGON_RADIUS * cos(PI/3), center - HEXAGON_RADIUS * sin(PI/3));
p[3] = new PVector(center + HEXAGON_RADIUS, center);
p[4] = new PVector(center + HEXAGON_RADIUS * cos(PI/3), center + HEXAGON_RADIUS * sin(PI/3));
p[5] = new PVector(center - HEXAGON_RADIUS * cos(PI/3), center + HEXAGON_RADIUS * sin(PI/3));
// </hexagon_points>


// <setup_charges>
PVector[] positives = new PVector[POSITIVE_CHARGES];
for(byte i = 0; i < positives.length; i++){
    positives[i] = new PVector(Math.round(random(HEXAGON_RADIUS)) + padding + 0.5 * HEXAGON_RADIUS, Math.round(random(HEXAGON_RADIUS)) + padding + 0.5 * HEXAGON_RADIUS);
}
PVector[] negatives = new PVector[NEGATIVE_CHARGES];
for(byte i = 0; i < negatives.length; i++){
    negatives[i] = new PVector(Math.round(random(HEXAGON_RADIUS)) + padding + 0.5 * HEXAGON_RADIUS, Math.round(random(HEXAGON_RADIUS)) + padding + 0.5 * HEXAGON_RADIUS);
}
// </setup_charges>


// <setup_colour_vectors>
PVector red = new PVector(-HEXAGON_RADIUS, 0);
red.normalize();
print(red.x);
PVector blue = new PVector(HEXAGON_RADIUS * cos(PI/3), HEXAGON_RADIUS * sin(PI/3));
blue.normalize();
PVector green = new PVector(HEXAGON_RADIUS * cos(PI/3), -(HEXAGON_RADIUS * sin(PI/3)));
green.normalize();
// </setup_colour_vectors>


// <draw_hexagon>
for(int i = 0; i < 5; i++){ 
    line(p[i].x, p[i].y, p[i+1].x, p[i+1].y);
}
line(p[5].x, p[5].y, p[0].x, p[0].y);
// </draw_hexagon>


loadPixels();
for (int i = floor(center - HEXAGON_RADIUS * sin(PI/3)); i < center + HEXAGON_RADIUS * sin(PI/3); i++) {
    int leftEndPoint = 0;
    int rightEndPoint = 0;
    
//  <find_endpoints_of_hexagon>  
    for(int j = padding; j < HEXAGON_RADIUS + padding; j++){
        if(pixels[width * i + j] == color(0, 0, 0)){
            leftEndPoint = j;
            break;
        }
    }
    for(int j = padding + HEXAGON_RADIUS * 2; j > padding + HEXAGON_RADIUS; j--){
        if(pixels[width * i + j] == color(0, 0, 0)){
            rightEndPoint = j;
            break;
        }
    }
//  </find_endpoints_of_hexagon>
//  <calculate_and_sum_force_vectors>
    PVector[] forces = new PVector[HEXAGON_RADIUS * 2];
    for(int j = padding; j < HEXAGON_RADIUS * 2 + padding; j++){
        if(leftEndPoint < j && j < rightEndPoint){
            for(int k = 0; k < positives.length; k++){
                float xDist = pow(j - positives[k].x, 2);
                float yDist = pow(i - positives[k].y, 2);
                float dist = sqrt(xDist + yDist);
                float mag = (dist != 0) ? 1 / (4 * PI * ELECTRIC_PERMITTIVITY) * Q / pow(dist, 2) : 1;
                PVector direction = new PVector(j - positives[k].x, i - positives[k].y);
                direction.normalize();
                PVector force = direction;
                force.mult(mag);
                if(forces[j - padding] == null){
                    forces[j - padding] = force;
                }else{
                    forces[j - padding].add(force);
                }
            }
            for(int k = 0; k < negatives.length; k++){
                float xDist = pow(j - negatives[k].x, 2);
                float yDist = pow(i - negatives[k].y, 2);
                float dist = sqrt(xDist + yDist);
                float mag = (dist != 0) ? 1 / (4 * PI * ELECTRIC_PERMITTIVITY) * Q / pow(dist, 2) : 1;
                PVector direction = new PVector(j - negatives[k].x, i - negatives[k].y);
                direction.normalize();
                PVector force = direction;
                force.mult(-mag);
                if(forces[j - padding] == null){
                    forces[j - padding] = force;
                }else{
                    forces[j - padding].add(force);
                }
            }
        }
    }
//  </calculate_and_sum_force_vectors>
//  <draw_pixels>
    for(int j = padding; j < HEXAGON_RADIUS * 2 + padding; j++){
        if(leftEndPoint < j && j < rightEndPoint){
            pixels[width * i + j] = color(max(sqrt(forces[j - padding].dot(red)), 0), max(sqrt(forces[j - padding].dot(blue)), 0), max(sqrt(forces[j - padding].dot(green)), 0));
        }
    }
//  </draw_pixels>
}
updatePixels();

// <draw_charges>
ellipseMode(CENTER);
strokeWeight(1);
for(int i = 0; i < positives.length; i++){
    ellipse(positives[i].x, positives[i].y, 3, 3);
}
fill(0, 0, 0);
stroke(255, 255, 255);
for(int i = 0; i < negatives.length; i++){
    ellipse(negatives[i].x, negatives[i].y, 3, 3);
}

// </draw_charges>




















// Digite aqui seu código GLSL para gerar uma imagem
// O GLSL é muito próximo do C, mas não é idêntico.

// Essa linha vai definir a precisão do float,
// e mediump é bom o bastante no momento.
precision mediump float;

// Aqui não tem conversão automática entre int e float
// Então coloque .0 quando precisar de floats

// As janelas tem um tamanho fixo de 3000x3000
#define WIDTH (3000.0)
#define HEIGHT (3000.0)

// Constantes do limite do plano cartesiano
#define Xi (-2.0)
#define Xj (+1.0)
#define Yi (-1.5)
#define Yj (+1.5)

#define Xd (Xj - Xi)
#define Yd (Yj - Yi)

float interpolate(float A, float B, float percentage) {
    return sqrt(A*A*(1.0-percentage) + B*B*(percentage));
}

// diferente do código em JS
// a GPU roda essa função main para cada pixel
void main() {
    float S[6];
    float R[6];
    float G[6];
    float B[6];

    S[0] = 0.0;
    S[1] = 10.0;
    S[2] = 80.0;
    S[3] = 150.0;
    S[4] = 200.0;
    S[5] = 255.0;

    R[0] = 0.0;
    R[1] = 32.0;
    R[2] = 237.0;
    R[3] = 255.0;
    R[4] = 100.0;
    R[5] = 0.0;

    G[0] = 7.0;
    G[1] = 107.0;
    G[2] = 255.0;
    G[3] = 170.0;
    G[4] = 120.0;
    G[5] = 0.0;

    B[0] = 100.0;
    B[1] = 203.0;
    B[2] = 255.0;
    B[3] = 0.0;
    B[4] = 0.0;
    B[5] = 0.0;

    // Aqui o pixel é guardado num vetor de 4 floats
    // Também segue o formato RGBA, mas dessa vez
    // os campos variam de 0.0 a 1.0

    // vamos obter as coordenadas do plano a partir da
    // variável gl_FragCoord que é pré definida para cada pixel
    vec2 xy = (gl_FragCoord.xy / vec2(WIDTH, HEIGHT) * vec2(Xd, Yd)) + vec2(Xi, Yi);

    // Para acessa o x ou o y individualmente é só usar
    // xy.x e xy.y respectivamente
    float x = xy.x;
    float y = xy.y;

    //****************************
    //compute a cor do pixel aqui
    float zx = 0.0;
    float zy = 0.0;
    float out_steps;
    for (int steps = 0; steps < 255; steps++) {
        float new_zx = zx*zx - zy*zy + x;
        float new_zy = 2.0*zx*zy + y;
        zx = new_zx;
        zy = new_zy;
        if ((zx*zx + zy*zy) > 4.0) {
            break;
        }
        out_steps += 1.0;
    }

    float s_table_r;
    float r_table_r;
    float g_table_r;
    float b_table_r;

    float s_table_l;
    float r_table_l;
    float g_table_l;
    float b_table_l;

    int idx = 0;
    for (int i = 0; i < 6; i++) {
        if (S[i] >= out_steps) {
            s_table_r = S[i];
            r_table_r = R[i];
            g_table_r = G[i];
            b_table_r = B[i];
            
            if (i > 0) {
                s_table_l = S[i-1];
                r_table_l = R[i-1];
                g_table_l = G[i-1];
                b_table_l = B[i-1];
            }
            idx = i;
            break;
        };
    }

    float percentage = 1.0;
    if (idx != 0) percentage = (out_steps - s_table_l)/(s_table_r - s_table_l);

    float red   = R[0]/255.0;
    float green = G[0]/255.0;
    float blue  = B[0]/255.0;

    if (idx > 0) {
        red   = interpolate(r_table_l, r_table_r, percentage)/255.0;
        green = interpolate(g_table_l, g_table_r, percentage)/255.0;
        blue  = interpolate(b_table_l, b_table_r, percentage)/255.0;
    }

    //*****************************
    // Aplica a cor
    gl_FragColor = vec4(red, green, blue, 1.0);
}

// Clique em Run GLSL para rodar o código ;)
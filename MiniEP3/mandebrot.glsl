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

float interpolate(A, B, percentage) {
    return sqrt(A*A*(1-percentage) + B*B*(percentage));
}

// diferente do código em JS
// a GPU roda essa função main para cada pixel
void main() {
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
    int out_steps;
    for (int steps = 0; steps < 255; steps++) {
        float new_zx = zx*zx - zy*zy + x;
        float new_zy = 2.0*zx*zy + y;
        zx = new_zx;
        zy = new_zy;
        if ((zx*zx + zy*zy) > 4.0) {
            break;
        }
        out_steps++;
    }

    float corrected = float(out_steps) / 255.0;

    float red = corrected;
    float green = corrected;
    float blue = corrected;

    //*****************************
    // Aplica a cor
    gl_FragColor = vec4(red, green, blue, 1.0);
}

// Clique em Run GLSL para rodar o código ;)
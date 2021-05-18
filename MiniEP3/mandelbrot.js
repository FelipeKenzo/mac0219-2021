// Digite aqui seu código JS para gerar uma imagem

// As janelas tem um tamanho fixo de 3000x3000
const WIDTH = 3000;
const HEIGHT = 3000;

// Constantes do limite o plano cartesiano
const Xi = -2.0;
const Xj = +1.0;
const Yi = -1.5;
const Yj = +1.5;

const Xd = Xj - Xi;
const Yd = Yj - Yi;

const S = [  0,  10,  80, 150, 200, 255]
const R = [  0,  32, 237, 255, 100,   0]
const G = [  7, 107, 255, 170, 120,   0]
const B = [100, 203, 255,   0,   0,   0]

const interpolate = (a, b, percentage) => {
    return Math.sqrt(a*a*(1-percentage) + b*b*(percentage))
}

const main = (data) => {
    //Data é um array de bytes que representa a imagem
    //O valor mínimo é 0 e o máximo é 255
    //A cada 4 bytes temos um pixel
    //Red Green Blue Alpha

    //Vamos usar o for para percorrer cada pixel
    for(let i = 0; i < data.length; i += 4) {
        const _x = Math.floor((i/4) % 3000);
        const _y = Math.floor((i/4) / 3000);

        //converte para um plano cartesiano indo de Xi-Xj e Yi-Yj.
        const x = Xi + (_x/WIDTH) * Xd;
        const y = Yj - (_y/HEIGHT) * Yd;

        //****************************
        //compute a cor do pixel aqui
        let zx = 0;
        let zy = 0;
        let steps = 0;
        while (steps < 255) {
            new_zx = zx*zx - zy*zy + x;
            new_zy = 2*zx*zy + y;
            zx = new_zx;
            zy = new_zy;
            if ((zx*zx + zy*zy) > 4) {
                break;
            }
            steps = steps + 1;
        }

        const idx = S.findIndex((s) => s >= steps);
        const percentage = idx ? (steps - S[idx-1])/(S[idx] - S[idx-1]) : 1.0;

        const red   = percentage != 1.0 ? interpolate(R[idx-1], R[idx], percentage) : R[idx];
        const green = percentage != 1.0 ? interpolate(G[idx-1], G[idx], percentage) : G[idx];
        const blue  = percentage != 1.0 ? interpolate(B[idx-1], B[idx], percentage) : B[idx];

        //*****************************
        
        //define a cor do pixel
        data[i]   = red;
        data[i+1] = green;
        data[i+2] = blue;
        data[i+3] = 255;
    }
};

// O nome da função a ser executada retornada deve aparecer no final
// clique em Run JS e aguarde um pouco para o seu código executar
main
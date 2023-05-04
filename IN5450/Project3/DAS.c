#include <stdio.h>
#include <math.h>
#include <complex.h>

void DAS(
    double complex *result,
    const double complex *mfdata, 
    const double *x_axis, 
    const double *y_axis,
    const int n_x, const int n_y,
    const double *rx, 
    const double *tx, 
    const int N_t, const int N_rx, const int N_tx,
    const double c,
    const double fs
) {
    // For each receiver and transmitter
    for(int i_rx = 0; i_rx < N_rx; i_rx++) {
        for(int i_tx = 0; i_tx < N_tx; i_tx++) {
            // Loop over grid
            for(int i_x = 0; i_x < n_x; i_x++) {
                for(int i_y = 0; i_y < n_y; i_y++){
                    // Calculate delay
                    const double rt = sqrt(pow(tx[i_tx]-x_axis[i_x],2) + pow(y_axis[i_y], 2));
                    const double rr = sqrt(pow(rx[i_tx]-x_axis[i_x],2) + pow(y_axis[i_y], 2));
                    const double t = (rt+rr)/c;

                    const int t_sample = (int)round(t * fs);

                    const int idx_2d = i_x*n_x+i_y;

                    if(t_sample >= 0 && t_sample < N_t) {
                        const int mfidx = t_sample; //*N_tx*N_rx+i_rx*N_tx+i_tx;
                        result[idx_2d] = mfdata[mfidx];
                    }
                }
            }
        }
        printf("Rx[%d] complete\n",i_rx+1);
    }
    printf("Done!\n");
}

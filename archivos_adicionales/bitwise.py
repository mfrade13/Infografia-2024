import cv2
import numpy as np



# dibujar un cuadrado
square = np.zeros((500, 500), np.uint8)
cv2.imshow("square_zeros", square)
square = cv2.cvtColor(square, cv2.COLOR_GRAY2RGB)
cv2.rectangle(square, (50, 50), (250, 250), (255,0,0), -2)
cv2.imshow("square", square)

#dibujar una elipse
ellipse = np.zeros((500, 500), np.uint8)
ellipse = cv2.cvtColor(ellipse, cv2.COLOR_GRAY2RGB)
cv2.ellipse(ellipse, (150, 150), (150, 150), 30, 0, 180, (0,0,255), -1)
cv2.imshow("elipse", ellipse)



cv2.waitKey()


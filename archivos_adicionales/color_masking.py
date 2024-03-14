import cv2
import numpy as np


lower = np.array([50,20,20])
upper = np.array([90,255,255])

video = cv2.VideoCapture(0)

while True:

    success, img = video.read()
    image = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    mask = cv2.inRange(image, lower, upper)
    masked_frame = cv2.bitwise_and(img, img, mask=mask)
    inverted_frame = cv2.bitwise_xor(img,img, mask=mask)
    countour, hierachy = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if countour != 0:
        for i in countour:
            if cv2.contourArea(i) >500:
                x,y,w,h = cv2.boundingRect(i)
                cv2.rectangle(img,  (x, y), (x+w, y+h), (0,0,255), 3   )


    cv2.imshow("mask", masked_frame)
    cv2.imshow("cam", img)
    cv2.imshow("cam", inverted_frame)
    key = cv2.waitKey(1)
    if key == 27:
        break

video.release()
cv2.destroyAllWindows()    

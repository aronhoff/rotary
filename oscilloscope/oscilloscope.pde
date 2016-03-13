  /*
 * Oscilloscope
 * Gives a visual rendering of analog pin 0 in realtime.
 * 
 * This project is part of Accrochages
 * See http://accrochages.drone.ws
 * 
 * (c) 2008 Sofian Audry (info@sofianaudry.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */ 
import processing.serial.*;

Serial port;  // Create object from Serial class
int histLength;
int[][] values;
int channels = 2;
float zoom;

void setup() 
{
  size(1280, 480);
  // Open the port that the board is connected to and use the same speed (9600 bps)
  port = new Serial(this, "/dev/ttyUSB0", 1000000);
  histLength = width*4;
  values = new int[channels][histLength];
  zoom = 1.0f;
  smooth();
  colorMode(RGB, 255);
}

int getY(int val) {
  return (int)(height - val / 1023.0f * (height - 1));
}

void getValue() {
  while (port.available() >= 1+channels*2) {
    if (port.read() == 0xff) {
      for(int i = 0; i < channels; i++) {
	    for (int j = 0; j < histLength-1; j++)
	      values[i][j] = values[i][j+1];
	    values[i][histLength-1] = (port.read() << 8) | (port.read());
      }
    }
  }
}

void drawLines() {
  int displayWidth = (int) (width / zoom);
  float xinc = (float)(width-1) / (displayWidth-1);
  int i0 = histLength - displayWidth;
  for (int i = histLength - displayWidth; i < histLength-1; i++) {
	for(int j = 0; j < channels; j++) {
	  strokeWeight(4);
	  if(j == 0) 
		stroke(0xff0066ff);
	  else if(j == 1) 
		stroke(0xffff0000);
	  else if(j == 2)
		stroke(0xff99cc00);
	  int x0 = (int)((i-i0) * xinc);
	  int x1 = (int)((i-i0 + 1) * xinc);
      int y0 = getY(values[j][i]);
      int y1 = getY(values[j][i+1]);
      line(x0, y0, x1, y1);
	}
  }
}

void drawGrid() {
	textSize(16);
	textAlign(LEFT, TOP);
	text("Zoom: "+zoom+"x", 4, 4);

	textSize(12);
	textAlign(RIGHT, CENTER);
	strokeWeight(1);
    stroke(150, 150, 0);
	for(int i = 1; i < 5; i++) {
    	line(0, i*height/5, width-30, i*height/5);
		text((5-i)+" V", width-4, i*height/5-2);
	}
    stroke(150, 150, 150);
	for(int i = 1; i < 10; i += 2)
		line(0, i*height/10, width, i*height/10);
}

void keyReleased() {
  switch (key) {
    case '+':
      zoom *= 2.0f;
      if ( (int) (width / zoom) <= 1 )
        zoom /= 2.0f;
      break;
    case '-':
      zoom /= 2.0f;
	  if(zoom < (float)(width)/histLength)
        zoom *= 2.0f;
      break;
	case ' ':
	  saveFrame("screenshot-###.png");
	  break;
  }
}

void draw()
{
  background(0);
  drawGrid();
  getValue();
  drawLines();
}

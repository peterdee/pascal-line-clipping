// Peter Dyumin, 2013
program LineClipping;

uses GraphABC;

var
  x1, y1, x2, y2, p1, p2, p3, p4: integer;
  c1, c2, c3, t1, t2: boolean;
  v, v2: color;

// draw the box
procedure ShutOffBox;
  begin
    line(0, 200, 900, 200, clsilver);
    line(200, 0, 200, 700, clsilver);
    line(0, 500, 900, 500, clsilver);
    line(700, 700, 700, 0, clsilver);
    line(200, 200, 200, 500, clblack);
    line(200, 500, 700, 500, clblack);
    line(700, 500, 700, 200, clblack);
    line(700, 200, 200, 200, clblack);
    floodfill(201, 201, rgb(235, 245, 255));
  end;

// generate the segment coordinates
procedure segment;
  begin
    repeat
      x1 := random(860) + 20;
      y1 := random(660) + 20;
      x2 := random(860) + 20;
      y2 := random(660) + 20;
    // make sure that the segment length is always > 1  
    until (x1 <> x2) and (y1 <> y2);
  end;

// draw the segment
procedure drawsegment;
  begin
    line(x1, y1, x2, y2, v);
    putpixel(x1 - 1, y1, v);
    putpixel(x1 + 1, y1, v);
    putpixel(x1, y1 - 1, v);
    putpixel(x1, y1 + 1, v);
    putpixel(x1 - 1, y1 - 1, v);
    putpixel(x1 + 1, y1 + 1, v);
    putpixel(x1 + 1, y1 - 1, v);
    putpixel(x1 - 1, y1 + 1, v);
    putpixel(x2 - 1, y2, v);
    putpixel(x2 + 1, y2, v);
    putpixel(x2, y2 - 1, v);
    putpixel(x2, y2 + 1, v);
    putpixel(x2 - 1, y2 - 1, v);
    putpixel(x2 + 1, y2 + 1, v);
    putpixel(x2 - 1, y2 + 1, v);
    putpixel(x2 + 1, y2 - 1, v);
  end;

// draw a small cross when crossing the box lines
procedure cross;
  begin
    p1 := round(((x2 - x1) / (y2 - y1)) * (200 - y1) + x1);
    p2 := round(((y2 - y1) / (x2 - x1)) * (200 - x1) + y1);
    p3 := round(((x2 - x1) / (y2 - y1)) * (500 - y1) + x1);
    p4 := round(((y2 - y1) / (x2 - x1)) * (700 - x1) + y1);
    v2 := clblack;
    line(p1 - 3, 197, p1 + 3, 203, v2);
    line(p1 - 3, 203, p1 + 3, 197, v2);
    line(197, p2 - 3, 203, p2 + 3, v2);
    line(203, p2 - 3, 197, p2 + 3, v2);
    line(p3 - 3, 497, p3 + 3, 503, v2);
    line(p3 - 3, 503, p3 + 3, 497, v2);
    line(697, p4 - 3, 703, p4 + 3, v2);
    line(703, p4 - 3, 697, p4 + 3, v2);
  end;

// determine if segment is fully visible or invisible in the box & draw it
procedure vision;
  begin
    // conditions
    c1 := false;
    c2 := false;
    c3 := false;
 
    // case 1: the segment is fully visible
    if ((x1 >= 200) and (x1 <= 700))
      and ((x2 >= 200) and (x2 <= 700))
      and ((y1 >= 200) and (y1 <= 500))
      and ((y2 >= 200) and (y2 <= 500)) then
      begin
        c1 := true;
        v := clgreen;
        drawsegment;
        cross;
      end;
 
    // case 2: the segment is fully invisible
    if ((x1 < 200) and (x2 < 200))
      or ((x1 > 700) and (x2 > 700))
      or ((y1 < 200) and (y2 < 200))
      or ((y1 > 500) and (y2 > 500)) then
        begin
          c2 := true;
          v := rgb(200, 100, 100);
          drawsegment;
          cross;
        end;
  end;


// case 3: find the clipping point if only one segment point is out
procedure ShutOff;
  begin
    if (c1 = false) and (c2 = false) then
      begin
        v := rgb(200, 100, 100);
        drawsegment;
        cross;
        t1 := false;
        t2 := false;
        if ((x1 >= 200) and (x1 <= 700)
          and (y1 >= 200) and (y1 <= 500)) then
          begin
            c3 := true;
            t1 := true;
          end;
        if ((x2 >= 200) and (x2 <= 700)
          and (y2 >= 200) and (y2 <= 500)) then
          begin
            c3 := true;
            t2 := true;
          end;
        if c3 = true then                                            
          begin 
            if (x1 > x2) and (t1 = true) then
              begin
                if ((p1 >= 200) and (p1 <= 700) and (y2 < 200)) then
                  line(x1, y1, p1, 200, clgreen);
                if ((p3 >= 200) and (p3 <= 700) and (y2 > 500)) then
                  line(x1, y1, p3, 500, clgreen);
                if ((p2 >= 200) and (p2 <= 500) and (x2 < 200)) then
                  line(x1, y1, 200, p2, clgreen);
              end;

            if (x1 > x2) and (t2 = true) then
              begin
                if ((p1 >= 200) and (p1 <= 700) and (y1 < 200)) then
                  line(x2, y2, p1, 200, clgreen);
                if ((p3 >= 200) and (p3 <= 700) and (y1 > 500)) then
                  line(x2, y2, p3, 500, clgreen);
                if ((p4 >= 200) and (p4 <= 500) and (x1 > 700)) then
                  line(x2, y2, 700, p4, clgreen);
              end;

            if (x2 > x1) and (t1 = true) then
              begin
                if ((p1 >= 200) and (p1 <= 700) and (y2 < 200)) then
                  line(x1, y1, p1, 200, clgreen);
                if ((p3 >= 200) and (p3 <= 700) and (y2 > 500)) then
                  line(x1, y1, p3, 500, clgreen);
                if ((p4 >= 200) and (p4 <= 500) and (x1 < 700)) then
                  line(x1, y1, 700, p4, clgreen);
              end;

            if (x2 > x1) and (t2 = true) then
              begin
                if ((p1 >= 200) and (p1 <= 700) and (y1 < 200)) then
                  line(x2, y2, p1, 200, clgreen);
                if ((p3 >= 200) and (p3 <= 700) and (y1 > 500)) then
                  line(x2, y2, p3, 500, clgreen);
                if ((p2 >= 200) and (p2 <= 500) and (x2 > 200)) then
                  line(x2, y2, 200, p2, clgreen);
              end;
          end;
      end;
  end;


// case 4: both segment points are out
procedure ShutOff2;
  begin
    if (c1 = false) and (c2 = false) and (c3 = false) then
      begin
        if ((p1 >= 200) and (p1 <= 700))
          and ((p2 >= 200) and (p2 <= 500)) then
          line(p1, 200, 200, p2, clgreen);
        if ((p1 >= 200) and (p1 <= 700))
          and ((p4 >= 200) and (p4 <= 500)) then
          line(p1, 200, 700, p4, clgreen);
        if ((p3 >= 200) and (p3 <= 700))
          and ((p2 >= 200) and (p2 <= 500)) then
          line(p3, 500, 200, p2, clgreen);
        if ((p3 >= 200) and (p3 <= 700))
          and ((p4 >= 200) and (p4 <= 500)) then
          line(p3, 500, 700, p4, clgreen);
        if ((p1 >= 200) and (p1 <= 700))
          and ((p3 >= 200) and (p3 <= 700)) then
          line(p1, 200, p3, 500, clgreen);
        if ((p2 >= 200) and (p2 <= 500))
          and ((p4 >= 200) and (p4 <= 500)) then
          line(200, p2, 700, p4, clgreen);
      end;
  end;

// handle the keyboard actions
procedure KeyDown(Key: integer);
  begin
    // run the app if "Space" is pressed
    if key = VK_Space then
      begin
        Clearwindow;
        ShutOffBox;
        segment;
        vision;
        ShutOff;
        ShutOff2;
        
        // print the segment coordinates
        SetFontSize(8);
        textout(3, 3, (IntToStr(x1)));
        textout(30, 3, (IntToStr(y1)));
        textout(3, 17, (IntToStr(x2)));
        textout(30, 17, (IntToStr(y2)));
      end;

      // close the app if "Enter" is pressed
      if key = VK_ENTER then closewindow;
  end;

// the main block
begin
  // set the window options
  SetWindowSize(900, 700);
  SetSmoothing(true);
  SetWindowCaption('Line Clipping');
  SetWindowIsFixedSize(true);
  
  // add some instructions
  SetFontSize(25);
  textout(210, 280, 'Press "SPACE" to continue');
  
  // let's go
  OnKeyDown := KeyDown;
end.

# you might have to add python libs
# ffprobe and ffmpeg need to be globally available.
# folders video and temp have to exist in the same directory as the script.

from PIL import Image
from pathlib import Path
from datetime import datetime
import glob, os, subprocess, re, ntpath, random

script_path = os.path.dirname(os.path.realpath(__file__)) + "\\"
video_path = script_path + "video\\"
temp_path = script_path + "temp\\"

#print(script_path)
#print(video_path)
#print(temp_path)

def createUnwrap(video_name, random_position=False):
    print("--------------------------------")
    print(video_name)
    start = datetime.now()

    video_info = subprocess.check_output('ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "' + video_name + '"', shell=True).decode("utf8")
    video_info = re.sub("[^0-9,]", "", video_info)
    video_info = video_info.split(',')

    video_width = int(video_info[0])
    video_height = int(video_info[1])
    print("Video width: " + str(video_width) + " Video height: " + str(video_height))

    if(random_position):
        pixelPos = random.randint(video_width*0.25,video_width*0.75)
    else:
        pixelPos = video_width/2
    print("Pixel position: " + str(pixelPos))

    subprocess.run('ffmpeg.exe -i "' + video_name +'" -filter:v "crop=2:' + str(video_height) + ':' + str(pixelPos) + ':1" -q:v 1 "' + temp_path + 'images-%04d.jpeg" -loglevel quiet')

    im_sequence = glob.glob(temp_path + "*.jpeg")
    im_size = (len(im_sequence), video_height)
    composite = Image.new("RGB", im_size)
    pix_col = 0

    for infile in im_sequence:
        file, ext = os.path.splitext(infile)
        im = Image.open(infile)
        im_center = video_width / 2
        im_strip = im.crop( (0, 0, 1, video_height) )
        composite.paste(im_strip, (pix_col, 0))
        pix_col += 1
        im.close()
        os.remove(infile)
    
    date_time = datetime.now().strftime("%Y%m%d_%H%M%S")
    image_name = script_path + "output\\" + Path(video_name).stem + "_" + date_time + ".jpeg"
    composite.save(image_name, "JPEG")
    print("Saved image as " + image_name)

    end = datetime.now()
    time = end-start
    print("Completed in " + "{:.2f}".format(time.total_seconds()) + " seconds.")

videos = glob.glob(video_path + "*.*")

totalstart = datetime.now()

for x in range(1):
    for video in videos:
        createUnwrap(video)

totalend = datetime.now()
time = totalend-totalstart
print("--------------------------------")
print("Program completed in " + "{:.2f}".format(time.total_seconds()) + " seconds.")
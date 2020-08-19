# you might have to add python libs
# ffprobe and ffmpeg need to be globally available.
# folders dest and temp have to exist in the same directory as the script.

from PIL import Image
from shutil import copyfile
from pathlib import Path
from datetime import datetime
import glob, ntpath, os, re, subprocess, time, csv

script_path = os.path.dirname(os.path.realpath(__file__)) + "\\"
video_name = "D:\\Videos\\Downloads\\Brooklyn Nine-Nine Cold Open.mp4"
temp_path = script_path + "temp\\"
dest_path = script_path + "dest\\"

def extractFrames():
    video_info = subprocess.check_output('ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "' + video_name + '"', shell=True).decode("utf8")
    video_info = re.sub("[^0-9,]", "", video_info)
    video_info = video_info.split(',')

    video_width = int(video_info[0])
    video_height = int(video_info[1])
    print("Video width: " + str(video_width) + " Video height: " + str(video_height))

    img_x = 65
    img_y = 590
    img_width = 500
    img_height = 100
    print('ffmpeg.exe -r 30 -i "' + video_name +'" -ss 00:00:15 -t 02:43:00 -filter:v "crop=' + str(img_width) + ':' + str(img_height) + ':' + str(img_x) + ':' + str(img_y) + '" -r 1 "' + temp_path + 'images-%05d.jpeg" ')
    #subprocess.run('ffmpeg.exe -r 30 -i "' + video_name +'" -ss 00:00:15 -t 02:43:00 -filter:v "crop=' + str(img_width) + ':' + str(img_height) + ':' + str(img_x) + ':' + str(img_y) + '" -r 1 "' + temp_path + 'images-%05d.jpeg" ') #-loglevel quiet

def get_average_color(x, y, n, image): 
    r, g, b = 240, 240, 16
    count = 0
    for s in range(x, x+n+1):
        for t in range(y, y+n+1):
            pxlR, pxlG, pxlB = image[s, t]
            if (pxlR > r and pxlG > g and pxlB < b):
                count += 1
    return count

def checkEachFrame():
    img_sequence = glob.glob(temp_path + "*.jpeg")
    titleCount = 0
    skipCount = 0
    minCount = 1000
    maxCount = 0

    for img in img_sequence:
        if (skipCount == 0):
            file, ext = os.path.splitext(img)
            image = Image.open(img).load()
            count = get_average_color(0, 0, 50, image)
            #image.close()

            if (count > 400):
                print(file,count)
                dest = dest_path + ntpath.basename(file) + ext
                copyfile(img, dest)

                titleCount += 1
                if (minCount > count):
                    minCount = count
                if (maxCount < count):
                    maxCount = count
                skipCount = 15
        else:
            skipCount -= 1

    print(titleCount,minCount,maxCount)

def createChapterFile(array):
    img_sequence = glob.glob(dest_path + "*.jpeg")
    i = 0
    s = 0

    for img in img_sequence:
        file, ext = os.path.splitext(img)
        timeInSeconds = re.sub("[^0-9,]", "", file)

        if (array[i][0] == '1'):
            s += 1

        line_out = time.strftime('%H:%M:%S', time.gmtime(int(timeInSeconds)-4)) + ".000 S" + str(s).zfill(2) + "E" + array[i][0].zfill(2) + " - " + array[i][1]
        print(line_out)
        i += 1

def readCsv():
    array = []

    with open(script_path + 'b99.csv') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        line_count = 0
        for row in csv_reader:
            array += [[row[0],row[1]]]

    return array


#extractFrames()
#checkEachFrame()
createChapterFile(readCsv())

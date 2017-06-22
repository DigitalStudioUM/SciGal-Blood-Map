import processing.svg.*;
JSONArray nameData;

PGraphics textCanvas;
PFont opensans;

//Size of text. Modify this to generate text in appropriate size (currently using 12,14,18 and 20)
int tSize = 20;

//Colours for fill and stroke. Does not affect image. Edit image file seperately for that.
color fillColour = color(0);
color outlineColour = color(255);

//Booleans to draw blood, language (tribe) and if there should be an audio icon after it or not.
boolean drawTribeWords = true;
boolean drawBloodWords = true;
boolean drawSpeakerIcon = true;

/**** SHADOW ****/
boolean withShadow = false;
//Offset for text to keep it in centre of image when adding a shadow. Also used for the offset of the shadow.
int textOffsetForShadow = 5;

PImage speakerImage;

void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);
  opensans = createFont("Open Sans Bold", tSize);
  textFont(opensans);

  nameData = loadJSONArray("json/generated.geojson"); //loading JSON with blood words and tribe names.
 
  speakerImage = loadImage("speaker-2.png"); //Loading file for image

  if (!withShadow) {
    textOffsetForShadow = 0;
  }
}

void draw() {

  if (drawTribeWords) {
    for (int i = 0; i < nameData.size(); i++) {
      String name = nameData.getJSONObject(i).getJSONObject("properties").getString("Tribe");
      if (drawSpeakerIcon) {
        //DrawWord("tribe", names[i], names[i]+"-"+tSize); //For adding a size number to it
        DrawWordWithAudio("tribe/"+tSize+"/", name, name);
      } else {
        DrawWord("tribe/"+tSize+"/", name, name);
      }
    }
  }

  if (drawBloodWords) {
    for (int i =0; i < nameData.size(); i++) {
      String[] bloodword = GetBloodWordAndTribe(i);

      if (!bloodword[0].equals("") && !bloodword[1].equals("")) {
        if (drawSpeakerIcon) {
          DrawWordWithAudio("blood/"+tSize+"/", bloodword[1], bloodword[0]+"-blood");
        } else {
          DrawWord("blood/"+tSize+"/", bloodword[1], bloodword[0]+"-blood");
        }
      }
    }
  }

  exit();
}

//Combined names
//String[] names = new String[] {"Adnyamathanha", "Aghu-Tharnggala", "Alawa", "Alyawarr", "Amurdak", "Anaiwan", "Anmatyerr", "Antekerrepenh", "Arabana", "Aranda (Lower)", "Atampaya", "Badjirri", "Bardi", "Barunggam", "Batjamalh", "Bilinarra", "Birrdhawal", "Boonwurrung", "Bundjalung", "Bunganditj", "Bunuba", "Burarra", "Butchulla", "Coobenpil", "Dalabon", "Darrkinyung", "Datiwuy", "Dhanggati", "Dharawal", "Dharug", "Dharumbal", "Dhurga", "Diyari", "Djabugay", "Djerraty", "Djinang", "Duungidjawu", "Dyirbal", "Eastern and Central Arrernte", "Gaagudju", "Gabi-Gabi", "Gamilaraay", "Garrwa", "Gathang", "Gidhabal", "Gooniyandi", "Gooreng Gooreng", "Gudang", "Gugu-Badhun", "Gugu-Yalanji", "Gumbaynggirr", "Gunditjmara", "Gunnai//Kurnai", "Gunya", "Gurindji", "Gurr-goni", "Guugu Yimidhirr", "Guwamu", "Hunter River-Lake Macquarie Language", "Iwaidja", "Jaru", "Jingulu", "Jiwarli", "Kala Lagaw Ya", "Kalkatungu", "Kamu", "Kaurna", "Kayardild", "Kaytej", "Keramin//Kureinji", "Kugu-Nganhcara", "Kukatja", "Kun-Barlang", "Kune", "Kungarakany", "Kunjen", "Kurtjar", "Kutanji", "Kuuk Thaayorre", "Kuuku Y'au", "Lamalama", "Lardil", "Limilngan", "Lower North Coast language", "Madhi-Madhi", "MalakMalak", "Malngin", "Malyangapa", "Mara", "Marbal", "Margany", "Marrithiyel", "Martu Wangka", "Martuthunira", "Matngele", "Mawng", "Mayi-Kulan", "Mayi-Kutuna", "Mayi-Thakurti", "Mayi-Yapi", "Mbabaram", "Merranunggu", "Minyangbal", "Miriwoong", "Mudbura", "Murrinhpatha", "Muruwari", "Na-Kara", "Narungga", "Ndjébbana", "Ngaanyatjarra", "Ngalakgan", "Ngan'gikurunggurr", "Ngan'gimerri", "Ngandi", "Ngarbal", "Ngari", "Ngarigu", "Ngarinman", "Ngarla", "Ngarluma", "Ngawun", "Ngiyampaa", "Ngunawal", "Nhanda", "Nukunu", "Nunggubuyu", "Nyawaygi", "Nyikina", "Nyulnyul", "Nyungar", "Paakantyi", "Pakanh", "Pallanganmiddang", "Panyjima", "Payungu", "Pintupi//Luritja", "Pitjantjatjara", "Pitta-Pitta", "Pungu Pungu", "Rembarrnga", "Rimanggudinhma", "Tati Tati", "Thalanyji", "Thawa", "The Omeo language", "Tiwi", "Umbugarla", "Wagiman", "Wakaya (East)", "Wakka Wakka", "Walmajarri", "Wambaya", "Wangkajunga", "Wangkanguru", "Wangkumarra", "Wardaman", "Warlpiri", "Warluwara", "Warnman", "Warray", "Warrgamay", "Warrongo", "Warumungu", "Watjarri", "Wembawemba", "Western Arrernte", "Wik-Mungkan", "Wik-Ngathan", "Wiradjuri", "Woiwurrung", "Wulguru", "Wunumara", "Yalarnnga", "Yandruwandha", "Yankunytjatjara", "Yanyuwa", "Yaraldi", "Yaygirr", "Yidiny", "Yindjibarndi", "Yingkarta", "Yinhawangka", "Yintyingka", "Yir-Yoront", "Yitha-Yitha", "Yolngu Matha", "Yorta Yorta", "Yugambeh", "Yukulta", "Yuwaalaraay", "Dangbon (Gadjalivia, Gungorogone)", "Pakadji", "Jupangati", "Djinba", "Njuwathai", "Rembarunga", "Diakui", "Winduwinda", "Totj", "Jinwum", "Djerait", "Wogait", "Pontunj", "Mbewum", "Dalabon", "Amijangal", "Kawadji", "Kandju", "Wikampama", "Wikmunkan", "Wikapatja", "Marijedi", "Ngalakan", "Wagoman", "Wikatinda", "Ngandi", "Ombila", "Wandarang", "Miwa", "Maridjabin", "Kamor", "Mariamo", "Wikepa", "Wik-Kalkan", "Wikmean", "Magatige", "Wunambal", "Kambure", "Wirngir", "Muringura", "Murinbata", "Barungguan", "Jilngali", "Mangarai", "Wiknatanja", "Wenambal", "Nanggumari", "Mara", "Mimungkum", "Jukul", "Bakanambia", "Walmbaria", "Djamindjung", "Mutumui", "Ajabatha", "Airiman", "Wikianji", "Jeteneru", "Wilawila", "Alawa", "Ithu", "Taior", "Duulngari", "Ajabakan", "Kadjerong", "Bilingara", "Ngarinjin", "Alura", "Jeidji", "Kokonjekodi", "Miriwung", "Wilingura", "Jangman", "Olkolo", "Marili", "Kokowara", "Kokangol", "Jirjoront", "Kokojawa", "Walu", "Ngewin", "Worora", "Ngaliwuru", "Kokoimudji", "Arnga", "Kokopera", "Laia", "Muragan", "Kokowalandja", "Kokobididji", "Kokobujundji", "Ola", "Ngarinman", "Kitja", "Jaudjibaia", "Kwarandji", "Wulpura", "Malngin", "Ngundjan", "Kokomini", "Jungkurara", "Lardiil", "Kokojelandji", "Karawa", "Ongkomi", "Jokula", "Wakara", "Kokokulunggur", "Korindji", "Muliridji", "Tjial", "Janggal", "Kaiadilt", "Irukandji", "Tjingili", "Tjapukai", "Kareldi", "Djankun", "Buluwai", "Wandjira", "Djaru", "Kongkandji", "Punaba", "Idindji", "Barbaram", "Njikena", "Wanji", "Ngatjan", "Madjandji", "Djirubal", "Wanjuru", "Mamu", "Ngoborindi", "Konejandi", "Walmadjari", "Karadjari", "Mangala", "Wulgurukaba", "Warakamai", "Ngardi", "Kokatja", "Njangamarda Kundal", "Bindal", "Ngaun", "Kaititja", "Juru", "Jaroinga", "Ngarla", "Nangatara", "Biria", "Gia", "Njamal(Pundju),(Widagari)", "Ngaro", "Kariara", "Waluwara", "Njangamarda(Iparuka)", "Jaburara", "Ngaluma", "Jangga", "Juipera", "Anmatjera", "Wiri", "Mandjildjara", "Indjibandi", "Ngolibardu", "Barna", "Koinjmal", "Wongkadjera", "Pitapita", "Bailgu", "Rungarungawa", "Barada", "Jambina", "Kurama", "Ringaringa", "Aranda(Northern)", "Jinigudira", "Darambal", "Wangan", "Kabalbara", "Rakkaia", "Jetimarala", "Baijungu", "Buruna", "Aranda(Central)", "Aranda", "Matuntara", "Mitaka", "Bidia", "Wadjalang", "Maia", "Kulumali", "Jeljendi", "Madoitja", "Taribelang", "Korenggoreng", "Pitjara", "Wulili", "Mandi", "Kongabula", "Ngulungbara", "Jauraworka", "Inggarda", "Nguri", "Karanguru", "Kunja", "Ngandangara", "Ngaiawongga", "Wakawaka", "Kabikabi", "Kungadutji", "Ngura Wota (Abandoned Territory)", "Batjala", "Karendala", "Djakunda", "Mandandanji", "Malgana", "Punthamara", "Barunggam", "Kaiabara", "Undanbi", "Nalbo", "Dalla", "Garumga", "Jarowair", "Dungidau", "Ngugi", "Dungibara", "Jagara", "Nunukul", "Pilatapa", "Ngurlu", "Parundji", "Kula", "Murunitja", "Wailpi", "Ualarai", "Weraerai", "Maduwongga", "Widjabal", "Tieraridjal", "Maljangapa", "Wanjiwalku", "Arakwal", "Ngurunta", "Jukambal", "Badjalang", "Kwiambal", "Baranbinja", "Ngarabal", "Jadliaura", "Ngemba", "Weilwan", "Naualko", "Jiegera", "Banbai", "Kumbainggiri", "Anaiwan", "Juat", "Balardong", "Kalaako", "Wongaibon", "Wiljakali", "Milpulo", "Dainggati", "Kawambarai", "Njakinjaki", "Ngaku", "Barkindji", "Ngadjuri", "Wiradjuri", "Nukunu", "Birpai", "Whadjuk", "Danggali", "Ngamba", "Geawegal", "Pindjarup", "Maraura", "Wonnarua", "Wiilman", "Worimi", "Kaurna", "Jitajita", "Narangga", "Darkinjang", "Awabakal", "Ngaiawang", "Ngawait", "Erawirung", "Daruk", "Kureinji", "Ngintait", "Muthimuthi", "Kaneang", "Wardandi", "Latjilatji", "Narinari", "Gandangara", "Peramangk", "Jarijari", "Eora", "Pibelmen", "Ngarkat", "Nganguruku", "Tatitati", "Warki", "Tharawal", "Watiwati", "Baraparapa", "Ngunawal", "Jarildekald", "Wodiwodi", "Portaulun", "Wembawemba", "Warki", "Warkawarka", "Jeithi", "Ramindjeri", "Wotobaluk", "Tanganekald", "Wandandian", "Jupagalk", "Jotijota", "Walgalu", "Walbanga", "Ngarigo", "Potaruwutj", "Jaara", "Kwatkwat", "Ngurelban", "Pangerang", "Marditjali", "Jaadwa", "Duduroa", "Djilamatang", "Meintangk", "Minjambuta", "Jaitmathang", "Djiringanj", "Bunganditj", "Taungurong", "Tjapwurong", "Thaua", "Brabiralung", "Wurundjeri", "Wathaurung", "Kurung", "Braiakaulung", "Krauatungalung", "Bidawal", "Gunditjmara", "Kirrae", "Bunurong", "Kolakngat", "Tatungalung", "Katubanut", "Bratauolung", "North East", "North", "Unoccupied", "Ben Lomond", "South East", "Gaari (Extinct)", "Jaako", "Nango,Djangu,Dangu,Duwala,Duwal", "Wurango", "Iwaidja", "Djalakuru", "Oitbi", "Djerimanga", "Ngardok", "Kakadu", "Ngormbur", "Norweilemil", "Beriguruk", "Djowei", "Puneitja", "Watta", "Awara", "Kungarakan", "Dall", "Awinmul", "Pongaponga", "Wulwulam", "Ingura", "Djauan", "Marimanindji", "Menthajangal", "Marithiel", "Tagoman", "Nunggubuju", "Junggor", "Madngela", "Marinunggo", "Nanggikorongo", "Maridan", "Karaman", "Wadere", "Bilingara", "Janjula", "Kwantari", "Binbinga", "Kotandji", "Mutpura", "Ongkarango", "Umede", "Djaui", "Kunggara", "Baada", "Kutjal", "Araba", "Njulnjul", "Warwa", "Nimanburu", "Kunindiri", "Djaberadjabera", "Wakaman", "Walangama", "Kalibamu", "Bingongina", "Mingin", "Ngombal", "Kukatja", "Maikulan", "Jawuru", "Wambaia", "Tagalag", "Kokopatun", "Bugulmara", "Djugun", "Waramanga", "Gulngai", "Walpiri", "Marrago", "Djiru", "Ewamin", "Keramai", "Maikudunu", "Maijabi", "Bandjin", "Warungu", "Nawagi", "Jangaa", "Indjilandji", "Wakabunga", "Wakaja", "Maithakari", "Kutjala", "Mitjamba", "Wanamara", "Kalkadunga", "Jirandali", "Iliaura", "Ilba", "Keiadjara(Ildawongga)", "Wanman", "Mardudunera", "Ngalia", "Jalanga", "Janda", "Noala", "Andakerebina", "Koa", "Pintubi", "Mian", "Jadira", "Iningai", "Maiawali", "Wongkamala", "Potidjara", "Kartudjara", "Aranda", "Talandji", "Pandjima", "Jumu", "Jagalingu", "Aranda(Western)", "Malintji", "Niabali", "Julaolinja", "Binigura", "Wenamba", "Kungkalenja", "Kukatja", "Inawonnga", "Tjuroro", "Kairi", "Mandara", "Lanima", "Kanolu", "Wirdinja", "Karanja", "Tenma", "Karuwali", "Kuungkari", "Ngadadjara", "Djiwali", "Pitjandjara", "Ngarlawongga", "Targari", "Wadjabangai", "Baiali", "Ninanu", "Kangulu", "Nana", "Marulta", "Wardal", "Wariangga", "Pitjara", "Wadja", "Tulua", "Goeng", "Malgaru", "Karingbal", "Wadjari", "Aranda", "Wongkanguru", "Antakirinja", "Jangkundjara", "Nakako", "Ngameni", "Mandjindja", "Pini", "Tedei", "Nanda", "Kunggari", "Maranganji", "Tjalkadjara", "Arabana", "Wongkumara", "Nokaan", "Dieri", "Nangatadjarra", "Barimaia", "Kokata", "Jandruwanta", "Koara", "Tirari", "Thereila", "Ngalea", "Kalali", "Bigambul", "Bitjara", "Giabal", "Badjiri", "Pindiini", "Morowari", "Koamu", "Wadikali", "Widi", "Jukambe", "Karenggapa", "Kamilaroi", "Waljen", "Koenpal", "Kambuwal", "Kalamaia", "Keinjan", "Kitabal", "Kujani", "Amangu", "Minjungbal", "Kalibal", "Mirning", "Wirangu", "Pangkala", "Ngadjunmaia", "Nauo", "Njunga", "Wudjari", "Disputed Territory", "Koreng", "Minang", "Kartan Culture", "North West", "Unoccupied", "North Midlands", "Big River", "Oyster Bay", "South West", "Kaurareg", "Otati", "Mutjati", "Jathaikana", "Djagaraga", "Tjongkandji", "Ankamuti", "Tepiti", "Nggamadi", "Unjadi", "Lotiga", "Ngathokudi", "Atjinuri", "Tunuvivi (Tiwi)", "Amarak", "Larakia", "Maung", "Gunwinggu", "Gambalang", "Djinang", "Barara", "Gunavidji", "Nakara", "Pongaponga"};

String[] GetBloodWordAndTribe(int i) {
  JSONObject b = nameData.getJSONObject(i).getJSONObject("properties");
  String[]r = new String[2];
  r[0] = b.getString("Tribe");
  r[1] = b.getString("Blood");
  return r;
}

void DrawWord(String prefix, String word, String filename) {
  textSize(tSize+3);
  int nameWidth = ceil( textWidth(word));
  if (withShadow) {
    textCanvas = createGraphics(nameWidth+textOffsetForShadow, 35+textOffsetForShadow);
  } else {
    textCanvas = createGraphics(nameWidth, 35);
  }
  textCanvas.smooth();
  textCanvas.beginDraw();
  textCanvas.textSize(tSize);
  textCanvas.textAlign(CENTER, CENTER);
  textCanvas.textFont(opensans);
  textCanvas.translate(textCanvas.width/2, textCanvas.height/2);

  //textCanvas.background(255,255,0);

  if (withShadow) {
    textCanvas.fill(outlineColour, 150);
    textCanvas.text(word, 0, 0);

    textCanvas.filter(BLUR, 3);
  }

  textCanvas.fill(outlineColour);
  for (int x = -1; x < 2; x++) {
    textCanvas.text(word, x-textOffsetForShadow, 0-textOffsetForShadow);
    textCanvas.text(word, 0-textOffsetForShadow, x-textOffsetForShadow);
  }

  textCanvas.fill(fillColour);
  textCanvas.text(word, 0-textOffsetForShadow, 0-textOffsetForShadow);

  textCanvas.endDraw();
  textCanvas.save(prefix + filename + ".png");
}

void DrawWordWithAudio(String prefix, String word, String filename) {
  textSize(tSize+3);
  int nameWidth = ceil( textWidth(word))+tSize;
  if (withShadow) {
    textCanvas = createGraphics(nameWidth+textOffsetForShadow, 35+textOffsetForShadow);
  } else {
    textCanvas = createGraphics(nameWidth, 35);
  }
  textCanvas.smooth();
  textCanvas.beginDraw();
  textCanvas.textSize(tSize);
  textCanvas.textAlign(CENTER, CENTER);
  textCanvas.textFont(opensans);
  textCanvas.pushMatrix();
  textCanvas.translate((textCanvas.width-tSize)/2, textCanvas.height/2);

  //textCanvas.background(255,255,0);

  if (withShadow) {
    textCanvas.fill(outlineColour, 150);
    textCanvas.text(word, 0, 0);

    textCanvas.filter(BLUR, 3);
  }

  textCanvas.fill(outlineColour);
  for (int x = -1; x < 2; x++) {
    textCanvas.text(word, x-textOffsetForShadow, 0-textOffsetForShadow);
    textCanvas.text(word, 0-textOffsetForShadow, x-textOffsetForShadow);
  }

  textCanvas.fill(fillColour);
  textCanvas.text(word, 0-textOffsetForShadow, 0-textOffsetForShadow);
  textCanvas.popMatrix();
  //Draw image after word at size of tSize.
  textCanvas.imageMode(CENTER);

  textCanvas.image(speakerImage, textCanvas.width-(tSize/2), (textCanvas.height/2)+(tSize/4), tSize, tSize);

  textCanvas.endDraw();
  textCanvas.save(prefix + filename + ".png");
}
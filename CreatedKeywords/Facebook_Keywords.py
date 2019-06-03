def VriendschapStatus(VriendStatus, Vriend, Kennis, GoedeVriend):
    if(VriendStatus == Vriend):
        vriend_status = "Vriend"
    elif (VriendStatus == Kennis):
        vriend_status = "Kennis"
    elif (VriendStatus == GoedeVriend):
        vriend_status = "Goede Vriend"
    else:
        print("Status onbekend")

    return vriend_status

def SplitTitle(PaginaTitle):
    # Splits op de spaties
    naam = PaginaTitle.split(" ")
    # Geef de 1e naam (= voornaam) uit de string terug.
    return naam[0]

def GeslachtBepalen(Geslacht, Man, Vrouw):
    if(Geslacht == Man):
        geslacht = "Man"
    elif (Geslacht == Vrouw):
        geslacht = "Vrouw"
    else:
        print("Geslacht onbekend")

    return geslacht

def SplitDatum(Datum):
    # Splits op de spaties
    jaar = Datum.split(" ")
    # Geef de 3e waarde (= jaar) uit de string terug.
    return jaar[2]

def LeeftijdBepalen(SysteemJaar, GeboorteJaar):
    SysteemJaar=int(SysteemJaar)
    GeboorteJaar=int(GeboorteJaar)
    leeftijd = SysteemJaar - GeboorteJaar
    return leeftijd

def CountVandaagJarig(Count_Vandaag_Jarig):
    Count_Jarigen = Count_Vandaag_Jarig
    return Count_Jarigen

def CountVandaagJarig_plus1(Count_Vandaag_Jarig_plus1):
    Count_Jarigen_plus1 = Count_Vandaag_Jarig_plus1 + 1
    return Count_Jarigen_plus1
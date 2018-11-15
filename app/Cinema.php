<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use App\Models\MyLibrary\MyConvert;

class Cinema extends Model
{
    protected $table = "Cinema";
    public $timestamps = false;

    //GET
    public static function QuickSearch(string $Name, int $CountDataInView, int $NumView){
        return DB::select('exec QuickSearchCinema ?, ?, ?', array($Name, $CountDataInView, $NumView));
    }
    
    public static function AdvancedSearch (string $Name, array $Genres, $Country, $Year,
    int $CountDataInView, int $NumView){
        $GenresStr = MyConvert::arrayToStr($Genres);
        return DB::select('EXEC AdvancedSearchCinema ?, ?, ?, ?, ?, ?', 
        array($Name, $GenresStr, $Country, $Year, $CountDataInView, $NumView));
    }
    
    public static function Top50(int $CountDataInView, int $NumView){
        return DB::select('exec GetTop50Cinema ?, ?', array($CountDataInView, $NumView));
    }
    
    public static function Novelties(int $CountDataInView, int $NumView){
        return DB::select('exec GetNoveltiesCinema ?, ?', array($CountDataInView, $NumView));
    }
    
    public static function SearchNovelties(int $CountDataInView, int $NumView, array $Genres){
        $GenresStr = MyConvert::arrayToStr($Genres);
        return DB::select('exec SearchNoveltiesCinema ?, ?, ?', array($CountDataInView, $NumView, $GenresStr));
    }
    
    public static function Announcements(int $CountDataInView, int $NumView){
        return DB::select('exec GetAnnouncementsCinema ?, ?', array($CountDataInView, $NumView));
    }
    
    public static function SearchAnnouncements(int $CountDataInView, int $NumView, array $Genres){
        $GenresStr = MyConvert::arrayToStr($Genres);
        return DB::select('exec SearchAnnouncementsCinema ?, ?, ?',
        array($CountDataInView, $NumView, $GenresStr));
    }

    //POST
    public static function Add(string $TypeOfCinema, string $CinemaName, string $CinemaOriginalName,
    string $SeasonName, string $SeasonOriginalName, int $AgeLimit, int $Year, string $Country,
    string $TagLine, string $SrcTrailer, string $MovieLengh, string $SrcPoster, string $Description,
    array $Directors, array $Actors, array $Genres){
        $DirectorsStr = MyConvert::arrayWithNameAndLastNameToStr($Directors);
        $ActorsStr = MyConvert::arrayWithNameAndLastNameToStr($Actors);
        $GenresStr = MyConvert::arrayToStr($Genres);
        DB::insert('exec CreateCinema ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?', 
        array($TypeOfCinema, $CinemaName, $CinemaOriginalName,
        $SeasonName, $SeasonOriginalName, $AgeLimit, $Year, $Country,
        $TagLine, $SrcTrailer, $MovieLengh, $SrcPoster, $Description,
        $DirectorsStr, $ActorsStr, $GenresStr));
    }
    
    //PUT
    public static function Edit(string $Name, string $NewName, 
    string $NewOriginalName, string $NewTypeOfCinema){
        DB::update('exec UpdateCinema ?, ?, ?, ?', 
        array($Name, $NewName, $NewOriginalName, $NewTypeOfCinema));
    }

    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteCinema ?', array($Id));
    }

}
<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Season extends Model
{
    protected $table = "Season";
    public $timestamps = false;
    
    //GET
    public static function GetAll($CinemaName, $CinemaOriginalName){
        return DB::select('exec GetSeasons ?, ?', array($CinemaName, $CinemaOriginalName));
    }
    
    public static function AllForAdmin($CinemaName, $CinemaOriginalName){
        return DB::select('exec GetSeasonsForAdmin  ?, ?', array($CinemaName, $CinemaOriginalName));
    }
    
    public static function GetSeasonInfo($CinemaName, $CinemaOriginalName, $SeasonNumber){
        return DB::select('exec GetSeasonInfo  ?, ?, ?',
        array($CinemaName, $CinemaOriginalName, $SeasonNumber));
    }
    
    //POST
    public static function Add($Name, $OriginalName, $CinemaName, $CinemaOriginalName,
    int $AgeLimit, int $Year, string $Country,string $Tagline,
    $SrcTrailer, string $MovieLength, $SrcPoster, $Description){
        DB::insert('exec CreateSeason ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?',
        array($Name, $OriginalName, $CinemaName, $CinemaOriginalName,
        $AgeLimit, $Year, $Country, $Tagline, $SrcTrailer,
        $MovieLength, $SrcPoster, $Description));
    }

    public static function AddView(string $CinemaName, $CinemaOriginalName, string $SeasonNumber){
        DB::insert('exec AddViewToSeason ?, ?, ?', array($CinemaName, $CinemaOriginalName, $SeasonNumber));
    }
    
    //PUT
    public static function Edit(int $Id, string $Name, string $OriginalName, int $AgeLimit, int $Year,
    string $Country, string $Tagline, string $SrcTrailer, string $MovieLength,
    string $SrcPoster, string $Description){
        DB::update('exec UpdateSeason ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?',
        array($Id, $Name, $OriginalName, $AgeLimit, $Year,
        $Country, $Tagline, $SrcTrailer, $MovieLength,
        $SrcPoster, $Description));
    }
    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteSeason ?', array($Id));
    }
    
}

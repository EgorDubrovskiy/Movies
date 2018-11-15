<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Video extends Model
{
    protected $table = "Video";
    public $timestamps = false;
    
    //GET
    public static function List(string $CinemaName, int $SeasonNumber){
        return DB::select('exec GetVideos ?, ?', array($CinemaName, $SeasonNumber));
    }
    
    public static function AllForAdmin(string $CinemaName, int $SeasonNumber){
        return DB::select('exec GetVideosForAdmin ?, ?', array($CinemaName, $SeasonNumber));
    }
    
    //POST
    public static function Add(int $IdSeason, string $Src){
        DB::insert('exec CreateVideo ?, ?', array($IdSeason, $Src));
    }
    
    //PUT
    public static function Edit(int $IdVideo, string $NewSrc){
        DB::update('exec UpdateVideo ?, ?', array($IdVideo, $NewSrc));
    }
    
    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteVideo ?', array($Id));
    }
    
}

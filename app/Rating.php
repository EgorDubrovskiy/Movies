<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Rating extends Model
{
    protected $table = "Rating";
    public $timestamps = false;
    
    //GET
    public static function GetRating(int $IdUser, int $IdSeason){
        return DB::select('exec GetRating ?, ?', array($IdUser, $IdSeason));
    }
    
    //POST
    public static function Add(int $IdUser, int $IdSeason, int $Rating){
        DB::insert('exec AddRating ?, ?, ?', array($IdUser, $IdSeason, $Rating));
    }
    
    //PUT
    public static function Edit(int $IdUser, int $IdSeason, int $NewRating){
        DB::update('exec UpdateRating ?, ?, ?', array($IdUser, $IdSeason, $NewRating));
    }
    
    //DELETE
    public static function Remove(int $IdUser, int $IdSeason){
        DB::delete('exec DeleteRating ?, ?', array($IdUser, $IdSeason));
    }
    
}

<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Comment extends Model
{
    protected $table = "Comment";
    public $timestamps = false;

    //GET
    public static function Search($UserLogin, $CinemaName, $SeasonNumber, $DateFrom, $DateTo){
        return DB::select('exec SearchComments ?, ?, ?, ?, ?',
        array($UserLogin, $CinemaName, $SeasonNumber, $DateFrom,$DateTo));
    }
    
    public static function Comments(string $CinemaName, int $SeasonNumber, int $CountDataInView, int $NumView){
        return DB::select('exec GetComments ?, ?, ?, ?',
        array($CinemaName, $SeasonNumber, $CountDataInView, $NumView));
    }
    
    //POST
    public static function Add(string $UserLogin, string $CinemaName, int $SeasonNumber, string $Text){
        return DB::insert('exec CreateComment ?, ?, ?, ?',
        array($UserLogin, $CinemaName, $SeasonNumber, $Text));
    }
    
    //PUT
    public static function Edit(int $Id, string $NewText){
        DB::update('exec UpdateComment ?, ?', array($Id, $NewText));
    }

    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteComment ?', array($Id));
    }

}

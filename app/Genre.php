<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Genre extends Model
{
    protected $table = "Genre";
    public $timestamps = false;
    
    //GET
    public static function List(int $Limit){
        return DB::select('exec GetGenres ?', array($Limit));
    }

    public static function Search(int $Limit, $Name){
        return DB::select('exec SearchGenres ?, ?', array($Limit, $Name));
    }

    //POST
    public static function Add(string $Name){
        DB::insert('exec AddGenre ?', array($Name));
    }
    
    //PUT
    public static function Edit(int $Id, string $NewName){
        DB::update('exec UpdateGenre ?, ?', array($Id, $NewName));
    }
    
    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteGenre ?', array($Id));
    }

}

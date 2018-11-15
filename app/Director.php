<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Director extends Model
{
    protected $table = "Director";
    public $timestamps = false;
    
    //GET
    public static function List(int $Limit){
        return DB::select('exec GetDirectors ?', array($Limit));
    }
    
    public static function Search(int $Limit, $Name, $LastName){
        return DB::select('exec SearchDirectors ?, ?, ?', array($Limit, $Name, $LastName));
    }

    //POST
    public static function Add(string $Name, string $LastName){
        DB::insert('exec AddDirector ?, ?', array($Name, $LastName));
    }

    //PUT
    public static function Edit(int $Id, string $NewName, string $NewLastName){
        DB::update('exec UpdateDirector ?, ?, ?', array($Id, $NewName, $NewLastName));
    }

    //DELETE
    public static function Remove(int $Id){
        DB::delete('exec DeleteDirector ?', array($Id));
    }

}


bool sameDay(DateTime x){

      if( DateTime.now().difference(x).inHours <= 24 )
        return true;

   return false;
}

bool sameWeek(DateTime x){

  if( DateTime.now().difference(x).inDays <= 7 && DateTime.now().difference(x).inDays >= 1 )
    return true;

  return false;
}

bool sameMonth(DateTime x){

  if( DateTime.now().difference(x).inDays <= 30 && DateTime.now().difference(x).inDays >= 1 )
    return true;

  return false;
}

bool sameYear(DateTime x){

  if( DateTime.now().difference(x).inDays <= 365 && DateTime.now().difference(x).inDays >= 1 )
    return true;

  return false;
}
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';

/// Get the version number of each master data
/// Returns a map with the master data as key and the version number as value
// Future<Map<String, double>> getMasterDataVersions() async {
//   final List<Map<String, dynamic>> maps =
//       await Supabase.instance.client.from('master_data_versions').select();

//   final Map<String, double> result = {};
//   for (var map in maps) {
//     final masterData = map['master_data'];
//     final version = map['version_number'];
//     switch (masterData) {
//       case 'city':
//         result['city_master_version'] = version;
//         break;
//       case 'club':
//         result['club_master_version'] = version;
//         break;
//       case 'company':
//         result['company_master_version'] = version;
//         break;
//       default:
//       // code to be executed for all other master data
//     }
//   }
//   return result;
// }

import 'package:http/http.dart' as http;

class Options {
  // Connection
  var conn;

  // Columns
  var athleteId = 0;
  var appVersion = 1.0;
  var gapWorkoutRequest = 3600000; // 1 hour
  var gapLeaderboardRequest = 900000; // 15 min
  var gapHdcLeaderboardRequest = 6000; // 1 min
  var showHdcLeaderboard = true;
  var clientId;
  var clientSecret;
  var directStrava;
  var cityMasterVersion = 0;
  var clubMasterVersion = 0;
  var companyMasterVersion = 0;
  var url = "http://runmaze-api.000webhostapp.com/web/images/HDC.jpg";
  var events = [];

  // Db connection
  Options(this.conn);

  Future<void> getClient() async {
    var sqlQuery;
    if (athleteId == 0) {
      sqlQuery = "SELECT client_id, client_secret, 0 as direct_strava "
          "FROM client_master WHERE is_active = 1 LIMIT 0,1";
    } else {
      sqlQuery = "SELECT client_id, client_secret, direct_strava "
          "FROM athlete_master WHERE row_id = $athleteId LIMIT 0,1";
    }
    var response = await http.get(Uri.parse(sqlQuery));
    var dataRow = response.body;
    clientId = dataRow['client_id'];
    clientSecret = dataRow['client_secret'];
    directStrava = dataRow['direct_strava'];
  }

  // Future<void> getEvents() async {
  //   if (athleteId == 0) {
  //     return;
  //   }

  //   var sqlQuery = "SELECT e.event_name, e.event_type, e.from_date, "
  //       "e.to_date, e.is_active, e.keep_display, e.fragment_number "
  //       "FROM sports_event e, event_participation p "
  //       "WHERE p.athlete_id = $athleteId AND p.is_active = 1 "
  //       "AND p.event_id = e.row_id AND e.keep_display = 1";

  //   var response = await http.get(Uri.parse(sqlQuery));
  //   var eventData = response.body;

  //   for (var row in eventData) {
  //     var e = {
  //       "event_name": row['event_name'],
  //       "event_type": row['event_type'],
  //       "from_date": row['from_date'],
  //       "to_date": row['to_date'],
  //       "is_active": row['is_active'],
  //       "keep_display": row['keep_display'],
  //       "fragment": row['fragment_number']
  //     };
  //     events.add(e);
  //   }
  // }

  Future<void> getEvents() async {
    if (athleteId == 0) {
      return;
    }

    final List<Map<String, dynamic>> rows = await Supabase.instance.client
        .from('sports_event').select()
        .select()
        .innerJoin('event_participation',
            on: 'event_id', equals: 'row_id')
        .eq('event_participation.athlete_id', athleteId)
        .eq('event_participation.is_active', true)
        .eq('sports_event.keep_display', true)
        .execute();

    for (var row in rows) {
      var e = {
        "event_name": row['sports_event.event_name'],
        "event_type": row['sports_event.event_type'],
        "from_date": row['sports_event.from_date'],
        "to_date": row['sports_event.to_date'],
        "is_active": row['sports_event.is_active'],
        "keep_display": row['sports_event.keep_display'],
        "fragment": row['sports_event.fragment_number']
      };
      events.add(e);
    }
  }



  // Future<void> getMasterDataVersions() async {
  //   var sqlQuery = "SELECT master_data, version_number FROM master_data_versions";

  //   var response = await http.get(Uri.parse(sqlQuery));
  //   var data = response.body;

  //   for (var row in data) {
  //     switch (row['master_data']) {
  //       case "city":
  //         cityMasterVersion = row['version_number'];
  //         break;
  //       case "club":
  //         clubMasterVersion = row['version_number'];
  //         break;
  //       case "company":
  //         companyMasterVersion = row['version_number'];
  //         break;
  //       default:
  //       //code to be executed for all other masterdata;
  //     }
  //   }
  // }

  Future<void> getMasterDataVersions() async {
    final List<Map<String, dynamic>> rows =
        await Supabase.instance.client.from('master_data_versions').select();

    for (var row in rows) {
      final masterData = row['master_data'];
      final version = row['version_number'];
      switch (masterData) {
        case 'city':
          cityMasterVersion = version;
          break;
        case 'club':
          clubMasterVersion = version;
          break;
        case 'company':
          companyMasterVersion = version;
          break;
        default:
        // code to be executed for all other master data
      }
    }
  }
}

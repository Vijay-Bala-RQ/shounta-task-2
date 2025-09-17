class LoginMockApiResponse {
  static const Map<String, dynamic> loginSuccessResponse = <String, dynamic>{
    'employee': <String, Object?>{
      'id': 259,
      'email': 'tcro1@gmail.com',
      'firstname': 'Test',
      'lastname': 'CRO',
      'isd_code': '+91',
      'phone_number': '7598573658',
      'offline_permission_enabled': true,
      'profile_pic_id': null,
      'profile_pic_url': null,
      'gender': 'male',
      'role_id': 9,
      'role_name': 'Branch MIS',
      'is_active': true,
      'code': 'TCRO1',
      'preferred_channel': <Object>[],
      'address': <String, Object?>{
        'id': 660,
        'addressable_type': 'Employee',
        'addressable_id': 259,
        'address_line_1': 'No.11 10',
        'address_line_2': 'vadaveethi subramaniyar kovilstreet',
        'city_id': 39,
        'city_name': 'Karakul',
        'state_id': 2,
        'state_name': 'Pondicherry',
        'pincode': '606601',
        'landmark': 'Test',
        'latitude': null,
        'longitude': null
      },
      'branches': <Map<String, Object?>>[
        <String, Object?>{
          'id': 58,
          'name': 'Kotagiri',
          'code': '20',
          'region_id': 1,
          'region_name': 'Chennai',
          'organisation_id': 1,
          'organisation_name': 'VGro',
          'responsible_employee_id': 212,
          'responsible_employee_firstname': 'Aravindh',
          'responsible_employee_lastname': 'S',
          'responsible_employee_profile_pic_url': null,
          'is_active': true
        },
        <String, Object?>{
          'id': 46,
          'name': 'Annur',
          'code': '15',
          'region_id': 1,
          'region_name': 'Chennai',
          'organisation_id': 1,
          'organisation_name': 'VGro',
          'responsible_employee_id': 130,
          'responsible_employee_firstname': 'Yabase',
          'responsible_employee_lastname': 'J',
          'responsible_employee_profile_pic_url': null,
          'is_active': true
        }
      ],
      'centers': <Object>[]
    },
    'token': <String, Object>{
      'access_token': 'I3MoAezLUsUWh6MQsTO_3Lj6iG2dQKzYB70gkKKTlZY',
      'token_type': 'bearer',
      'expires_in': 86400,
      'refresh_token':
          'fb6dfa4ffe09c59f4d0c7db8306661185c74c91bf375e4bfac2d0e5dd469199d',
      'created_at': '2024-03-05T20:19:56.749Z'
    }
  };

  static const Map<String, dynamic> unauthorizedLoginResponse = <String, dynamic>{
    'error': 'Email or Password is incorrect.'
  };
}

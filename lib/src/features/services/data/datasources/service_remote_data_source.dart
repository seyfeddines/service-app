import '../../../../core/error/exceptions_without_message.dart';
import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getAllServices();
}

/// Fake DataSource (للتجريب والتست)
class FakeServiceRemoteDataSource implements ServiceRemoteDataSource {
  FakeServiceRemoteDataSource();

  static final List<ServiceModel> _fakeServices = [
    const ServiceModel(
      id: '1',
      name: 'Cleaning',
      image: 'https://imgs.search.brave.com/iKxmrNta3tsQxAVMWfqL961VW4JyL9FhKKtv-dfxNN8/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90aHVt/YnMuZHJlYW1zdGlt/ZS5jb20vYi9oYW5k/LWdsb3Zlcy1jbGVh/bmluZy1ob3VzZS13/aXBpbmctZHVzdC1k/ZXNrLWJlZHJvb20t/MTI1MjAzMDUxLmpw/Zw',
    ),
    const ServiceModel(
      id: '2',
      name: 'Plumbing',
      image: 'https://imgs.search.brave.com/EZF7gUc8xlyk6CB7KczrtPRp_9VFNMIxlPSobMY9C78/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zMy1t/ZWRpYTAuZmwueWVs/cGNkbi5jb20vYnBo/b3RvL2FtR2ZPRTJZ/NkxnQUp0TWxPcTQz/SUEvbHMuanBn',
    ),
    const ServiceModel(
      id: '3',
      name: 'Electrician',
      image: 'https://imgs.search.brave.com/QPK-ugWix4I_Lcn8OXeJuGan76gq66t0eHZbyjL6JfM/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMTM4/NTQwNzc3Mi9waG90/by9lbGVjdHJpY2lh/bi13b3JraW5nLW9u/LWNvbnN0cnVjdGlv/bi1zaXRlLmpwZz9z/PTYxMng2MTImdz0w/Jms9MjAmYz1BcF9f/cG9IWXFpUmxEWkR2/eW0wLThnUjdkYmZO/N1diWHNlWUVHTy1T/V3ZRPQ',
    ),
    const ServiceModel(
      id: '4',
      name: 'Painting',
      image: 'https://imgs.search.brave.com/OstjZXzA5s-Rq4wSORmcqbo-zsfweHcvZ87GG8uuJOM/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMudW5zcGxhc2gu/Y29tL3Bob3RvLTE1/MTE4MjIxNDg3OTAt/ZTdiNThiYTE0Yzcy/P2ZtPWpwZyZxPTYw/Jnc9MzAwMCZpeGxp/Yj1yYi00LjEuMCZp/eGlkPU0zd3hNakEz/ZkRCOE1IeHpaV0Z5/WTJoOE9IeDhkMkZz/YkNVeU1IQmhhVzUw/YVc1bmZHVnVmREI4/ZkRCOGZId3c',
    ),
  ];

  @override
  Future<List<ServiceModel>> getAllServices() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
      return _fakeServices;
    } catch (error) {
      throw ServerException();
    }
  }
}

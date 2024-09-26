
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:journal_web/core/common/widgets/custom_dropdown.dart';
import 'package:journal_web/core/common/widgets/custom_text_field.dart';
import 'package:journal_web/core/common/widgets/snack_bars.dart';
import 'package:journal_web/core/const/fields_const.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AuthorSignup extends StatelessWidget {
  const AuthorSignup({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    AuthorModel tempAuthor = AuthorModel();
    return Scaffold(
      appBar: AppBar(
        title: Text('Register as Author'),
        centerTitle: true,
        elevation: 2,
      ),
      body: ResponsiveBuilder(builder: (context, sizingInfo) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: (sizingInfo.isDesktop || sizingInfo.isTablet)
                  ? context.width * 0.15
                  : 16,
              vertical: (sizingInfo.isDesktop || sizingInfo.isTablet)
                  ? context.height * 0.1
                  : 0,
            ),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Wrap(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdown<String>(
                          label: 'Title',
                          width: 150,
                          items: titleMenuEntries,
                          onSelected: (value) {
                            tempAuthor.title = value;
                          },
                        ),
                        CustomTextField(
                          label: 'First Name',
                          width: 350,
                          onChanged: (v) => tempAuthor.firstName = v,
                        ),
                        CustomTextField(
                          label: 'Middle',
                          width: 200,
                          onChanged: (v) => tempAuthor.middle = v,
                        ),
                        CustomTextField(
                          label: 'Last Name',
                          width: 350,
                          onChanged: (v) => tempAuthor.lastName = v,
                        ),
                        CustomTextField(
                          label: 'Email',
                          width: 400,
                          onChanged: (v) => tempAuthor.mail = v,
                        ),
                        CustomTextField(
                          label: 'ORCID',
                          width: 200,
                          onChanged: (v) => tempAuthor.orcId = v,
                        ),
                        CustomTextField(
                          label: 'Username',
                          width: 250,
                          onChanged: (v) => tempAuthor.username = v,
                        ),
                        CustomTextField(
                          label: 'Password',
                          width: 250,
                          onChanged: (v) => tempAuthor.password = v,
                        ),
                        CustomDropdown(
                          label: 'Designation',
                          width: 200,
                          onSelected: (v) => tempAuthor.designation = v,
                          items: designationMenuEntries,
                        ),
                        CustomTextField(
                          label: 'Specialization',
                          width: 200,
                          onChanged: (v) => tempAuthor.specialization = v,
                        ),
                        CustomTextField(
                          label: 'Speicific Field of Study',
                          width: 200,
                          onChanged: (v) => tempAuthor.fieldOfStudy = v,
                        ),
                        CustomTextField(
                          label: 'Phone',
                          width: 150,
                          onChanged: (v) => tempAuthor.phone = v,
                        ),

                        CSCPicker(
                          onCountryChanged: (c) {
                            tempAuthor.country = c;
                          },
                          onStateChanged: (s) {
                            tempAuthor.state = s;
                          },
                          onCityChanged: (city) {
                            tempAuthor.city = city;
                          },
                          flagState: CountryFlag.DISABLE,
                        ),
                        CustomTextField(
                          label: 'Pincode',
                          width: 200,
                          onChanged: (v) => tempAuthor.pinCode = v,
                        ),
                        // Expanded(child: SizedBox()),
                        CustomTextField(
                          label: 'Address',
                          width: 300,
                          onChanged: (v) => tempAuthor.address = v,
                        ),
                      ],
                    ),
                    SizedBox(height: context.height * 0.1),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoadingState) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Center(
                          child: GFButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (tempAuthor.title == null ||
                                    tempAuthor.title == '') {
                                  MySnacks.showErrorSnack(
                                      'Title Cant be empty');
                                } else if (tempAuthor.country == null) {
                                  MySnacks.showErrorSnack(
                                      'Country Cant be empty');
                                } else {
                                  context.read<LoginBloc>().add(
                                      LoginAuthorSignupEvent(
                                          author: tempAuthor));
                                }
                              }
                            },
                            text: 'Submit',
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

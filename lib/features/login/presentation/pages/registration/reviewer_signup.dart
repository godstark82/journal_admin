import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:journal_web/core/common/widgets/custom_dropdown.dart';
import 'package:journal_web/core/common/widgets/custom_text_field.dart';
import 'package:journal_web/core/common/widgets/snack_bars.dart';
import 'package:journal_web/core/const/fields_const.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ReviewerSignup extends StatelessWidget {
  const ReviewerSignup({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    ReviewerModel tempReviewer = ReviewerModel();
    return Scaffold(
      appBar: AppBar(
        title: Text('Register as Reviewer'),
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
                            tempReviewer.title = value;
                          },
                        ),
                        CustomTextField(
                          label: 'Full Name',
                          width: 350,
                          onChanged: (v) => tempReviewer.name = v,
                        ),

                        CustomTextField(
                          label: 'Email',
                          width: 400,
                          onChanged: (v) => tempReviewer.email = v,
                        ),

                        CustomTextField(
                          label: 'Password',
                          width: 250,
                          onChanged: (v) => tempReviewer.password = v,
                        ),
                        CustomTextField(
                          label: 'Journal Name',
                          width: 200,
                          onChanged: (v) => tempReviewer.journal = v,
                        ),

                        CustomTextField(
                          label: 'Mobile',
                          width: 150,
                          onChanged: (v) => tempReviewer.mobile = v,
                        ),

                        CustomTextField(
                          label: 'Country',
                          width: 150,
                          onChanged: (v) => tempReviewer.country = v,
                        ),

                        // Expanded(child: SizedBox()),
                        CustomTextField(
                          label: 'Corresponding Address',
                          width: 300,
                          onChanged: (v) =>
                              tempReviewer.correspondingAddress = v,
                        ),
                        CustomTextField(
                          label: 'Details CV',
                          width: 300,
                          onChanged: (v) => tempReviewer.detailsCV = v,
                        ),
                        CustomTextField(
                          label: 'Research Domains',
                          width: 300,
                          onChanged: (v) => tempReviewer.researchDomain = v,
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
                                if (tempReviewer.title == null ||
                                    tempReviewer.title == '') {
                                  MySnacks.showErrorSnack(
                                      'Title Cant be empty');
                                } else if (tempReviewer.country == null) {
                                  MySnacks.showErrorSnack(
                                      'Country Cant be empty');
                                } else {
                                  context.read<LoginBloc>().add(
                                      LoginReviewerSignupEvent(
                                          reviewer: tempReviewer));
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

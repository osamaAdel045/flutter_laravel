import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/core/enums/viewsate.dart';
import 'package:flutter_laravel/core/models/server.dart';
import 'package:flutter_laravel/core/models/site.dart';
import 'package:flutter_laravel/core/viewmodels/servers_model.dart';
import 'package:flutter_laravel/server_types.dart';
import 'package:flutter_laravel/ui/components/buttons/main_button.dart';
import 'package:flutter_laravel/ui/components/separator.dart';
import 'package:flutter_laravel/ui/router.dart';
import 'package:flutter_laravel/ui/shared/loading_indicator.dart';
import 'package:flutter_laravel/ui/widgets/editor.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'base_view.dart';

class SiteView extends StatefulWidget {
  final Site? site;
  final Server? server;

  const SiteView({Key? key, this.site, this.server}) : super(key: key);

  @override
  SiteViewState createState() => SiteViewState();
}

class SiteViewState extends State<SiteView> {
  late final Observable<bool> quickDeployment;

  @override
  void initState() {
    quickDeployment = Observable(widget.site!.quickDeploy!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ServersViewModel>(
      onModelReady: (model) async {},
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          title: Text(
            widget.site!.name!,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: model.state == ViewState.Busy
            ? loadingIndicator()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Commands',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.all(5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Status',
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.site!.status!,
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Separator(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Type',
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.site!.projectType!,
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Separator(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Quick deployment',
                                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Observer(
                                    builder: (context) => CupertinoSwitch(
                                      value: quickDeployment.value,
                                      onChanged: (bool value) {
                                        showCustomAlertDialog(context,
                                            "Are you sure you want to ${value ? "enable" : "disable"} Quick deployment ?",
                                            () {
                                          Navigator.of(context).pop();
                                          reaction((p0) => quickDeployment.value = value, (p0) {});
                                          if (value) {
                                            // model.enableQuickDeployment((widget.server!.id!).toString(),(widget.site!.id!).toString());
                                          } else {
                                            // model.disableQuickDeployment((widget.server!.id!).toString(),(widget.site!.id!).toString());
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Commands',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (ServerTypes.loadBalancer != widget.server!.type!.toLowerCase())
                      item('Deploy Site', () {
                        showCustomAlertDialog(context, "Are you sure you want to Deploy this Site ?", () {
                          Navigator.of(context).pop();
                          // model.deploySite(widget.server!.id.toString(), widget.site!.id.toString());
                        });
                      }),
                    if (ServerTypes.hasNginx.contains(widget.server!.type!.toLowerCase()))
                      item('Nginx Configuration', () async {
                        String? nginx = await model.getNginx(widget.server!.id.toString(), widget.site!.id.toString());
                        if (mounted) {
                          showEditor(
                            context,
                            nginx!,
                            widget.site?.name ?? '',
                            (newText) {
                              print(newText);
                              // model.updateNginx(widget.server!.id.toString(), widget.site!.id.toString(),newText);
                            },
                          );
                        }
                      }),
                    if (ServerTypes.loadBalancer != widget.server!.type!.toLowerCase())
                      item(
                        'Edit .env',
                        () async {
                          String? env = await model.getEnv(widget.server!.id.toString(), widget.site!.id.toString());
                          if (mounted) {
                            showEditor(
                              context,
                              env!,
                              widget.site?.name ?? '',
                              (newText) {
                                print(newText);
                                // model.updateEnv(widget.server!.id.toString(), widget.site!.id.toString(),newText);
                              },
                            );
                          }
                        },
                      ),
                    if (ServerTypes.loadBalancer != widget.server!.type!.toLowerCase())
                      item(
                        'Show Deployments',
                        () async {
                          Navigator.pushNamed(
                            context,
                            Routes.deployments,
                            arguments: [widget.site, widget.server],
                          );
                        },
                      ),
                    if (ServerTypes.loadBalancer != widget.server!.type!.toLowerCase())
                      item('Execute Command', () {
                        showExecute(context, model);
                      }),
                    item('SSL/Lets Encrypt', () {
                      showSSLLetsEncrypt(context, widget.site!.name!);
                    }),
                    item('Visit Site', () async {
                      String url = "";
                      bool defaultSite = widget.site!.name!.trim() == "default";
                      if (defaultSite) {
                        url = 'http://${widget.server!.ip_address}';
                      } else {
                        url = 'https://www.${widget.site!.name}';
                      }
                      if (await canLaunchUrl(Uri(path: url, scheme: defaultSite ? "http" : "https"))) {
                        await launchUrlString(url, mode: LaunchMode.externalApplication);
                      }
                    }),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget item(String name, VoidCallback? onPressed) {
    return MainButton(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      fontWeight: FontWeight.w500,
      textAlign: TextAlign.start,
      text: name,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: Colors.green,
      overlayColor: Colors.green.withOpacity(0.5),
    );
  }

  // showEditor(BuildContext context, String env, ServersViewModel model, Function(String newText) onPressed) {
  //   TextEditingController controller = TextEditingController(text: env);
  //   final numLines = Observable('\n'.allMatches(env).length + 1);
  //
  //   return showModalBottomSheet(
  //     context: context,
  //     backgroundColor: const Color(0xff191B1C),
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     enableDrag: false,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) => Scaffold(
  //           backgroundColor: Colors.transparent,
  //           resizeToAvoidBottomInset: true,
  //           body: SafeArea(
  //             child: Column(
  //               children: [
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Container(
  //                   margin: const EdgeInsets.all(8),
  //                   color: Colors.white10,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: const Text(
  //                           'Cancel',
  //                           style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
  //                         ),
  //                       ),
  //                       Text(
  //                         widget.site!.name!,
  //                         style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
  //                       ),
  //                       TextButton(
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                           onPressed.call(controller.text);
  //                         },
  //                         child: const Text(
  //                           'Save',
  //                           style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     child: ConstrainedBox(
  //                       constraints: BoxConstraints.expand(width: 800),
  //                       child: ListView(
  //                         children: [
  //                           Row(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Expanded(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
  //                                   child: ListView.builder(
  //                                     itemBuilder: (context, index) => Text(
  //                                       (index + 1).toString(),
  //                                       textAlign: TextAlign.center,
  //                                       style: const TextStyle(color: Colors.grey, fontSize: 14),
  //                                     ),
  //                                     shrinkWrap: true,
  //                                     physics: NeverScrollableScrollPhysics(),
  //                                     itemCount: numLines.value,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Expanded(
  //                                 flex: 9,
  //                                 child: TextField(
  //                                   autofocus: true,
  //                                   controller: controller,
  //                                   decoration: const InputDecoration(
  //                                     filled: true,
  //                                     focusedBorder: OutlineInputBorder(
  //                                         borderRadius: BorderRadius.all(Radius.circular(0)),
  //                                         borderSide: BorderSide(
  //                                           color: Colors.transparent,
  //                                         )),
  //                                     enabledBorder: OutlineInputBorder(
  //                                         borderRadius: BorderRadius.all(Radius.circular(0)),
  //                                         borderSide: BorderSide(
  //                                           color: Colors.transparent,
  //                                         )),
  //                                     contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
  //                                     border: OutlineInputBorder(
  //                                         borderRadius: BorderRadius.all(Radius.circular(0)),
  //                                         borderSide: BorderSide(
  //                                           color: Colors.transparent,
  //                                         )),
  //                                   ),
  //                                   style: const TextStyle(color: Colors.white, fontSize: 14),
  //                                   keyboardType: TextInputType.multiline,
  //                                   maxLines: null,
  //                                   onChanged: (value) {
  //                                     print('object');
  //                                     setState(() {
  //                                       numLines.value = '\n'.allMatches(value).length + 1;
  //                                     });
  //                                   },
  //                                 ),
  //                               ),
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  showSSLLetsEncrypt(BuildContext context, String domain) {
    final TextEditingController controller = TextEditingController(text: domain);

    showCustomDialog("Install SSL/Lets Encrypt\nWhich Domains", controller, 'Cancel', 'Ok', () {});
  }

  showExecute(BuildContext context, ServersViewModel model) {
    final TextEditingController controller = TextEditingController();

    showCustomDialog("Execute command", controller, 'Cancel', 'Execute', () {
      // model.executeCommand(widget.server!.id.toString(), widget.site!.id.toString(),controller.text);
    });
  }

  showCustomDialog(
      String title, TextEditingController controller, String textButton1, String textButton2, VoidCallback onPressed) {
    return showDialog(
      barrierColor: const Color(0xff191B1C).withOpacity(0.6), // your color
      context: context,
      builder: (context) => Theme(
        data: ThemeData.dark(),
        child: CupertinoAlertDialog(
          title: Text(title),
          content: Material(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xff191B1C),
                  hoverColor: Color(0xff191B1C),
                  focusColor: Color(0xff191B1C),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        color: Color(0xff191B1C),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      )),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      )),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
                child: Text(textButton1), textStyle: TextStyle(fontSize: 14), onPressed: () => Navigator.pop(context)),
            CupertinoDialogAction(child: Text(textButton2), onPressed: onPressed, textStyle: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  showCustomAlertDialog(BuildContext context, String title, VoidCallback onPressed) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        actions: [
          CupertinoDialogAction(
              child: Text("Cancel"), textStyle: TextStyle(fontSize: 14), onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(child: Text('Ok'), onPressed: onPressed, textStyle: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../Layouts/BarrelFileLayouts.dart';

class MoreinfoBlogsscreen extends StatelessWidget {
  const MoreinfoBlogsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlogPostLayout(
          imagePath: 'lib/assets/images/jpeg/spmc.jpg',
          title: 'Balancing the right treatments for metastatic cancer',
          author: 'Author Name',
          publishDate: 'September 24, 2024',
          content:
              'Cancer immunotherapy has had a significant impact on cancer treatment, transforming the landscape of oncology and providing hope for patients. Unlike traditional therapies such as chemotherapy and radiation, which target cancer cells directly, immunotherapy works by stimulating or enhancing the immune response, enabling it to recognize and destroy cancer cells more effectively. \n\nWhile immunotherapy has improved survival rates for various cancers, including melanoma, kidney cancer, lung cancer, colon cancer, and certain types of leukemia and lymphoma, not all patients respond to this new form of treatment. Ralph Weichselbaum, MD, the Daniel K. Ludwig Distinguished Service Professor and Chair of Radiation and Cellular Oncology at the University of Chicago, and Sean Pitroda, MD, an Associate Professor of Radiation and Cellular Oncology, recently published a study in the Journal of Clinical Oncology reviewing data on the effectiveness of immunotherapy in metastatic cancer, where the disease has spread to other sites in the body. Their analysis suggests that in some cases, traditional local treatments like radiation or surgery might work as well or delay the need for immunotherapy or other systemic therapies, and have less toxic side effects. The following is an edited conversation about their findings.',
        ),
      ),
    );
  }
}

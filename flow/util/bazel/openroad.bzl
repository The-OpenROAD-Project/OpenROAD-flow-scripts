load("@aspect_bazel_lib//lib:run_binary.bzl", "run_binary")

def build_openroad(
    name,
    source_folder_name = None,
    synth_sources = [],
    post_synth_sources = [],
    dependencies = [],
    output_folder_name = None,
    arguments = [],
    macros = [],
    synth_args = [],
    post_synth_args = []   
):
    if source_folder_name == None:
        source_folder_name = name

    if output_folder_name == None:
        output_folder_name = source_folder_name

    all_sources = [
        "orfs"
    ]

    run_binary(
        name = "%s_synth" %(name),
        tool = ":orfs",
        srcs = macros + synth_sources + dependencies + all_sources,
        args = ["make",
            "WORK_HOME=$(RULEDIR)/build"] + synth_args + [
            "synth"
        ],
        outs = [
            "build/results/asap7/%s/base/1_synth.v" %(output_folder_name),
            "build/results/asap7/%s/base/1_synth.sdc" %(output_folder_name)
        ]
    )

    run_binary(
        name = name,
        tool = ":orfs",
        srcs = macros + post_synth_sources + dependencies + all_sources + [":%s_synth" %(name)],
        args = ["make",
            "WORK_HOME=$(RULEDIR)/build"] + post_synth_args + [
            "do-floorplan", "do-place", "do-cts", "do-route", "do-finish", "do-generate_abstract"
        ],
        outs = [
            "build/results/asap7/%s/base/%s.lib" %(output_folder_name, name),
            "build/results/asap7/%s/base/%s.lef" %(output_folder_name, name),
            "build/results/asap7/%s/base/6_final.odb" %(output_folder_name),
            "build/results/asap7/%s/base/6_final.gds" %(output_folder_name),
        ],
        out_dirs = [
            "logs/%s/base/" % output_folder_name,
            "objects/%s/base/" % output_folder_name,
            "reports/%s/base/" % output_folder_name,
            "all_results/%s/base/" % output_folder_name,
        ]
    )

package org.xtext.gradle.tasks.internal

import groovy.lang.Closure
import java.io.File
import java.util.List
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.gradle.api.Project
import org.gradle.api.file.FileTree
import org.gradle.api.file.FileTreeElement
import org.gradle.api.specs.Spec
import org.gradle.api.tasks.util.PatternFilterable
import org.gradle.api.tasks.util.PatternSet
import org.gradle.util.ConfigureUtil
import org.xtext.gradle.tasks.XtextExtension
import org.xtext.gradle.tasks.XtextSourceDirectorySet
import org.xtext.gradle.tasks.XtextSourceSetOutputs
import org.gradle.api.Action

class DefaultXtextSourceDirectorySet implements XtextSourceDirectorySet {
	@Accessors val String name
	@Accessors val XtextSourceSetOutputs output
	@Accessors val filter = new PatternSet
	Project project
	List<Object> source = newArrayList

	new(String name, Project project, XtextExtension xtext) {
		this.name = name
		this.project = project
		output = new DefaultXtextSourceSetOutputs(project, xtext)
	}

	override XtextSourceDirectorySet srcDir(Object srcDir) {
		source += srcDir
		return this
	}

	override XtextSourceDirectorySet srcDirs(Object... srcDirs) {
		source += srcDirs
		return this
	}

	override XtextSourceDirectorySet setSrcDirs(Iterable<?> srcDirs) {
		source.clear
		source += srcDirs
		return this
	}

	override FileTree getFiles() {
		return project.files(srcDirs).asFileTree.matching(filter)
	}

	override Set<File> getSrcDirs() {
		return project.files(source).files.filter[!output.dirs.contains(it)].toSet
	}

	override PatternFilterable getFilter() {
		return filter
	}

	override Set<String> getIncludes() {
		return filter.includes
	}

	override Set<String> getExcludes() {
		return filter.excludes
	}

	override PatternFilterable setIncludes(Iterable<String> includes) {
		filter.setIncludes(includes)
		return this
	}

	override PatternFilterable setExcludes(Iterable<String> excludes) {
		filter.setExcludes(excludes)
		return this
	}

	override PatternFilterable include(String... includes) {
		filter.include(includes)
		return this
	}

	override PatternFilterable include(Iterable<String> includes) {
		filter.include(includes)
		return this
	}

	override PatternFilterable include(Spec<FileTreeElement> includeSpec) {
		filter.include(includeSpec)
		return this
	}

	override PatternFilterable include(Closure includeSpec) {
		filter.include(includeSpec)
		return this
	}

	override PatternFilterable exclude(Iterable<String> excludes) {
		filter.exclude(excludes)
		return this
	}

	override PatternFilterable exclude(String... excludes) {
		filter.exclude(excludes)
		return this
	}

	override PatternFilterable exclude(Spec<FileTreeElement> excludeSpec) {
		filter.exclude(excludeSpec)
		return this
	}

	override PatternFilterable exclude(Closure excludeSpec) {
		filter.exclude(excludeSpec)
		return this
	}

	override output(Closure<?> configureAction) {
		ConfigureUtil.configure(configureAction, output)
	}
	
	override output(Action<XtextSourceSetOutputs> action) {
		action.execute(output)
	}

	override getGeneratorTaskName() {
		if (name == "main") {
			"generateXtext"
		} else {
			"generate" + name.toFirstUpper + "Xtext"
		}
	}

	override String toString() {
		return source.toString()
	}

}